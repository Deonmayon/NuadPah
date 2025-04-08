import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/api/auth.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardSet.dart';
import '../../api/massage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/favorite_manager.dart';
import 'dart:async';

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  State<Favouritepage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<Favouritepage> {
  int _selectedTab = 0;
  bool isLoading = true;

  List<dynamic> favSingleMassages = [];
  List<dynamic> favSetMassages = [];

  Map<String, dynamic> userData = {
    'email': '',
    'first_name': '',
    'last_name': '',
    'image_name': '',
    'role': '',
  };

  String userEmail = '';

  @override
  void initState() {
    super.initState();
    FavoriteManager.instance.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = true;
      });
      loadData();
    });
  }

  Future<void> loadData() async {
    try {
      // First get user email (needed for subsequent queries)
      bool userEmailSuccess = await getUserDataBool();

      // Only proceed with fetching massages if we successfully got the user email
      if (userEmailSuccess && userEmail.isNotEmpty) {
        // Then fetch both single and set massages in parallel
        await Future.wait([
          fetchSingleMassages(),
          fetchSetMassages(),
        ]);
      } else {
        // Handle the case where we couldn't get the user email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('ไม่สามารถโหลดข้อมูลผู้ใช้ได้ กรุณาลองใหม่อีกครั้ง')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch user data from local storage
  Future<bool> getUserDataBool() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedUserData = prefs.getString('userData');

    if (cachedUserData == null) {
      return false; // User data not found
    } else {
      final decodedUserData = jsonDecode(cachedUserData);

      setState(() {
        userData = decodedUserData;
        userEmail = decodedUserData['email'];
      });

      return true;
    }
  }

  Future<void> fetchSingleMassages() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getFavSingle(userEmail);

      if (response.data.isEmpty) {
        setState(() {
          favSingleMassages = [];
        });
        return;
      }

      final List<int> favMassages = (response.data as List)
          .map((item) => Map<String, dynamic>.from(item)['mt_id'] as int)
          .toList();

      // Update global favorite manager
      FavoriteManager.instance.setSingleFavorites(favMassages);

      // Cache favorites for faster future loads
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList(
          'cachedFavorites', favMassages.map((id) => id.toString()).toList());

      setState(() {
        favSingleMassages = (response.data as List)
            .map((item) => item.map((key, value) => MapEntry(key, value)))
            .toList();
      });
    } catch (e) {
      setState(() {
        "Error fetching single massages: ${e.toString()}";
      });
    }
  }

  Future<void> fetchSetMassages() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getFavSet(userEmail);

      if (response.data.isEmpty) {
        setState(() {
          favSetMassages = [];
        });
        return;
      }

      final List<int> favMassages = (response.data as List)
          .map((item) => Map<String, dynamic>.from(item)['mt_id'] as int)
          .toList();

      // Update global favorite manager
      FavoriteManager.instance.setSetFavorites(favMassages);

      // Cache favorites for faster future loads
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('cachedSetFavorites',
          favMassages.map((id) => id.toString()).toList());

      setState(() {
        favSetMassages = response.data as List;
      });
    } catch (e) {
      setState(() {
        "Error fetching set massages: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ท่านวดที่บันทึกไว้',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ],
        ),
        elevation: 1,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTabButton('ท่านวดเดี่ยว', 0),
                  _buildTabButton('เซ็ตท่านวด', 1),
                ],
              ),
            ),
            Expanded(
              child: _selectedTab == 0
                  ? isLoading
                      ? _buildLoadingWidget()
                      : SingleMassageTab(
                          massages: favSingleMassages,
                          onFavoriteChanged: _handleSingleFavoriteChanged,
                        )
                  : isLoading
                      ? _buildLoadingWidget()
                      : SetOfMassageTab(
                          massages: favSetMassages,
                          onFavoriteChanged: _handleSetFavoriteChanged,
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        initialIndex: 3,
        onTap: (index) {},
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          SizedBox(height: 16),
          Text(
            'เกิดข้อผิดพลาด กรุณาลองใหม่',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'กำลังโหลดข้อมูล...',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF676767),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          width: 186,
          height: 52,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: isSelected ? Color(0xFFC0A172) : Colors.white,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Color(0xFFB1B1B1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSingleFavoriteChanged(
      bool isFavorite, int massageId) async {
    final apiService = MassageApiService();

    try {
      if (isFavorite) {
        await apiService.favSingle(userEmail, massageId);
        if (!favSingleMassages.contains(massageId)) {
          setState(() {
            favSingleMassages.add(massageId);
          });
        }
      } else {
        await apiService.unfavSingle(userEmail, massageId);
        setState(() {
          favSingleMassages.remove(massageId);
        });
      }

      // Update global state
      FavoriteManager.instance.updateSingleFavorite(massageId, isFavorite);

      // Update cache
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('cachedFavorites',
          favSingleMassages.map((id) => id.toString()).toList());
    } catch (e) {
      print("Error toggling favorite: $e");
      // Could implement retry logic here
    }
  }

  Future<void> _handleSetFavoriteChanged(bool isFavorite, int massageId) async {
    final apiService = MassageApiService();

    try {
      if (isFavorite) {
        await apiService.favSingle(userEmail, massageId);
        if (!favSetMassages.contains(massageId)) {
          setState(() {
            favSetMassages.add(massageId);
          });
        }
      } else {
        await apiService.unfavSingle(userEmail, massageId);
        setState(() {
          favSetMassages.remove(massageId);
        });
      }

      // Update global state
      FavoriteManager.instance.updateSingleFavorite(massageId, isFavorite);

      // Update cache
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('cachedSetFavorites',
          favSetMassages.map((id) => id.toString()).toList());
    } catch (e) {
      print("Error toggling favorite: $e");
      // Could implement retry logic here
    }
  }
}

class SingleMassageTab extends StatelessWidget {
  final List<dynamic> massages;
  final Function(bool, int) onFavoriteChanged;

  const SingleMassageTab({
    required this.massages,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (massages.isEmpty) {
      return Center(
        child: Text(
          'ไม่มีท่านวดที่บันทึกไว้',
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 135, 135, 135),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: massages.length,
      itemBuilder: (context, index) {
        final massage = massages[index];
        final List<int> favMassages = (massages as List<dynamic>? ?? [])
            .map((item) => item['mt_id'] as int)
            .toList();
        final bool isFavorite = favMassages.contains(massage['mt_id'].toInt());
        return MassageCard(
          mtID: massage['mt_id'].toInt() ?? 0,
          image: massage['mt_image_name'] ??
              'https://picsum.photos/seed/picsum/200/300',
          name: massage['mt_name'] ?? 'Unknown Massage',
          detail: massage['mt_detail'] ?? 'No description available.',
          type: massage['mt_type'] ?? 'Unknown Type',
          time: massage['mt_time'] ?? 'Unknown Duration',
          rating: massage['avg_rating']?.toString(),
          isFavorite: isFavorite,
          isSet: false,
          onFavoriteChanged: (isFavorite) {
            onFavoriteChanged(isFavorite, massage['mt_id']);
          },
        );
      },
    );
  }
}

class SetOfMassageTab extends StatelessWidget {
  final List<dynamic> massages;
  final Function(bool, int) onFavoriteChanged;

  const SetOfMassageTab({
    required this.massages,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (massages.isEmpty) {
      return Center(
        child: Text(
          'ไม่มีเซ็ตท่านวดที่บันทึกไว้',
          style: TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 135, 135, 135),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: massages.length,
      itemBuilder: (context, index) {
        final massage = massages[index];
        final List<int> favMassages = (massages as List<dynamic>? ?? [])
            .map((item) => item['ms_id'] as int)
            .toList();
        final bool isFavorite = favMassages.contains(massage['ms_id'].toInt());

        return MassageCardSet(
          msID: (massage['ms_id'] ?? 0) as int,
          title: (massage['ms_name'] ?? 'Unknown Title') as String,
          description:
              (massage['ms_detail'] ?? 'No description available.') as String,
          types: (massage['ms_types'] as List<dynamic>? ?? []).cast<String>(),
          duration: (massage['ms_time'] ?? 0) as int,
          images:
              ((massage['ms_image_names'] as List<dynamic>? ?? []).isNotEmpty &&
                      massage['ms_image_names'].length > 0
                  ? massage['ms_image_names']
                  : 'https://picsum.photos/seed/picsum/200/300'),
          rating: massage['avg_rating']?.toString(),
          isFavorite: isFavorite,
          onFavoriteChanged: (isFavorite) {
            onFavoriteChanged(isFavorite, massage['ms_id']);
          },
        );
      },
    );
  }
}
