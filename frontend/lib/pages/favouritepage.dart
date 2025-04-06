import 'package:flutter/material.dart';
import 'package:frontend/api/auth.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardSet.dart';
import '../../api/massage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Favouritepage extends StatefulWidget {
  const Favouritepage({Key? key}) : super(key: key);

  @override
  State<Favouritepage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<Favouritepage> {
  int _selectedTab = 0;

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
    loadData();
  }

  Future<void> loadData() async {
    await getUserEmail();
    await fetchSingleMassages();
    await fetchSetMassages();
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService(baseUrl: dotenv.env['API_URL'] ?? '');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token is null, user not logged in.");
      return;
    }

    try {
      final response = await apiService.getUserData(token);

      print("User data: ${response.data}"); // Debugging line

      setState(() {
        userData = response.data;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> fetchSingleMassages() async {
    final apiService = MassageApiService(baseUrl: dotenv.env['API_URL'] ?? '');

    try {
      final response = await apiService.getFavSingle(userData['email']);

      setState(() {
        favSingleMassages = (response.data as List)
            .map((item) => item.map((key, value) => MapEntry(key, value)))
            .toList();
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> fetchSetMassages() async {
    final apiService = MassageApiService(baseUrl: dotenv.env['API_URL'] ?? '');

    try {
      final response = await apiService.getFavSet(userData['email']);

      setState(() {
        favSetMassages = response.data as List;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}");
        print(userData); // Only prints error message
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
                  ? SingleMassageTab(massages: favSingleMassages)
                  : SetOfMassageTab(massages: favSetMassages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        initialIndex: 3, // หน้าแรกเริ่มที่ Home
        onTap: (index) {},
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
}

class SingleMassageTab extends StatelessWidget {
  final List<dynamic> massages;

  const SingleMassageTab({required this.massages});

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
          mt_id: massage['mt_id'] ?? 0,
          // image: massage['mt_image_name'] ??
          //     'https://picsum.photos/seed/picsum/200/300',
          image: 'https://picsum.photos/seed/picsum/200/300',
          name: massage['mt_name'] ?? 'Unknown Massage',
          detail: massage['mt_detail'] ?? 'No description available.',
          type: massage['mt_type'] ?? 'Unknown Type',
          time: massage['mt_time'] ?? 'Unknown Duration',
          onFavoriteChanged: (isFavorite) {
            print('Massage favorited: $isFavorite');
          },
        );
      },
    );
  }
}

class SetOfMassageTab extends StatelessWidget {
  final List<dynamic> massages;

  const SetOfMassageTab({required this.massages});

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
        final imageNames = massage['ms_image_names'] as List<dynamic>? ?? [];

        return MassageCardSet(
          ms_id: (massage['ms_id'] ?? 0) as int,
          title: (massage['ms_name'] ?? 'Unknown Title') as String,
          description:
              (massage['ms_detail'] ?? 'No description available.') as String,
          types: (massage['ms_types'] as List<dynamic>? ?? []).cast<String>(),
          duration: (massage['ms_time'] ?? 0) as int,
          // imageUrl1: imageNames.isNotEmpty
          //     ? imageNames[0] as String
          //     : 'https://picsum.photos/seed/default1/200/300',
          // imageUrl2: imageNames.length > 1
          //     ? imageNames[1] as String
          //     : 'https://picsum.photos/seed/default2/200/300',
          // imageUrl3: imageNames.length > 2
          //     ? imageNames[2] as String
          //     : 'https://picsum.photos/seed/default3/200/300',
          imageUrl1: 'https://picsum.photos/seed/default1/200/300',
          imageUrl2: 'https://picsum.photos/seed/default2/200/300',
          imageUrl3: 'https://picsum.photos/seed/default3/200/300',
          onFavoriteChanged: (isFavorite) {
            // Replace with a logging framework or remove in production
          },
        );
      },
    );
  }
}
