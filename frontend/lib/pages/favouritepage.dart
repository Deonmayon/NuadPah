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

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    loadData();
  }

  Future<void> loadData() async {
    try {
      // First get user email (needed for subsequent queries)
      bool userEmailSuccess = await getUserEmail();

      // Only proceed with fetching massages if we successfully got the user email
      if (userEmailSuccess && userData['email'].isNotEmpty) {
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

  Future<bool> getUserEmail() async {
    final apiService = AuthApiService();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('Token not found');
      return false;
    }

    // Try up to 3 times to get user data
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await apiService.getUserData(token).timeout(
          Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Request timed out');
          },
        );

        setState(() {
          userData = response.data;
        });
        return true;
      } catch (e) {
        print('Attempt $attempt: Error fetching user data: ${e.toString()}');
        if (attempt == 3) {
          // If this was the last attempt, we failed
          return false;
        }
        // Wait a bit before retrying
        await Future.delayed(Duration(seconds: 1));
      }
    }

    return false; // Should never reach here due to the for loop, but needed for compilation
  }

  Future<void> fetchSingleMassages() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getFavSingle(userData['email']);

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
      final response = await apiService.getFavSet(userData['email']);

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
      if (!isFavorite) {
        // Update FavoriteManager first for immediate UI change across the app
        FavoriteManager.instance.updateSingleFavorite(massageId, false);

        // Remove from local state
        setState(() {
          favSingleMassages
              .removeWhere((massage) => massage['mt_id'] == massageId);
        });

        // Then perform API call
        await apiService.unfavSingle(userData['email'], massageId);
      }
    } catch (e) {
      // Revert changes if API call fails
      FavoriteManager.instance.updateSingleFavorite(massageId, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('การอัปเดตรายการโปรดล้มเหลว กรุณาลองใหม่')),
      );
    }
  }

  Future<void> _handleSetFavoriteChanged(bool isFavorite, int massageId) async {
    final apiService = MassageApiService();

    try {
      if (!isFavorite) {
        // Update FavoriteManager first for immediate UI change across the app
        FavoriteManager.instance.updateSetFavorite(massageId, false);

        // Remove from local state
        setState(() {
          favSetMassages
              .removeWhere((massage) => massage['ms_id'] == massageId);
        });

        // Then perform API call
        await apiService.unfavSet(userData['email'], massageId);
      }
    } catch (e) {
      // Revert changes if API call fails
      FavoriteManager.instance.updateSetFavorite(massageId, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('การอัปเดตรายการโปรดล้มเหลว กรุณาลองใหม่')),
      );
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
        return MassageCard(
          mtID: massage['mt_id'].toInt() ?? 0,
          image: massage['mt_image_name'] ??
              'https://picsum.photos/seed/picsum/200/300',
          name: massage['mt_name'] ?? 'Unknown Massage',
          detail: massage['mt_detail'] ?? 'No description available.',
          type: massage['mt_type'] ?? 'Unknown Type',
          time: massage['mt_time'] ?? 'Unknown Duration',
          rating: massage['avg_rating']?.toString(),
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
          onFavoriteChanged: (isFavorite) {
            onFavoriteChanged(isFavorite, massage['ms_id']);
          },
        );
      },
    );
  }
}
