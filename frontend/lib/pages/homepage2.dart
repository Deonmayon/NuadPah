import 'package:flutter/material.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardLarge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth.dart';
import '../../api/massage.dart';

class HomepageWidget extends StatefulWidget {
  final String email;

  const HomepageWidget({Key? key, required this.email}) : super(key: key);

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> recmassages = [];
  List<dynamic> massages = [];

  String selectedType = 'all massages';

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
    Future.wait([getUserEmail()]);
    Future.wait([fetchRecMassages()]);
    Future.wait([fetchMassages()]);
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService(baseUrl: 'http://10.0.2.2:3001');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token is null, user not logged in.");
      return;
    }

    try {
      final response = await apiService.getUserData(token);

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

  Future<void> fetchRecMassages() async {
    final apiService = MassageApiService(baseUrl: 'http://10.0.2.2:3001');

    try {
      final response = await apiService.getReccomendMassages(userData['email']);

      setState(() {
        recmassages = (response.data as List)
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

  Future<void> fetchMassages() async {
    final apiService = MassageApiService(baseUrl: 'http://10.0.2.2:3001');

    try {
      final response = await apiService.getAllMassages();

      setState(() {
        massages = response.data as List;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredMassages = selectedType == 'all massages'
        ? recmassages
        : recmassages.where((massage) {
            if (massage['ms_types'] != null) {
              return massage['ms_types'].contains(selectedType);
            } else if (massage['mt_type'] != null) {
              return massage['mt_type'] == selectedType;
            }
            return false; // If both are null, exclude from results
          }).toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'สวัสดี, Esther',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'ยินดีต้อนรับเข้าสู่ NuadPah',
                    style: TextStyle(
                      color: Color(0xFF676767),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              ClipOval(
                child: Image.asset(
                  'assets/images/profilePicture.jpg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          centerTitle: false,
          toolbarHeight: 70,
          elevation: 2,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    'แนะนำสำหรับคุณ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('All massages'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('Back'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('Arm'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('Shoulder'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('Neck'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 280, // Set the height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredMassages.length,
                    itemBuilder: (context, index) {
                      final massage = filteredMassages[index];
                      return MassageCardLarge(
                        name: massage['name'] ?? 'Unknown Name',
                        score: massage['avg_rating'] != null
                            ? '${massage['avg_rating']} / 5'
                            : 'N/A',
                        type: (massage['mt_type'] ??
                                (massage['ms_types']?.join(', ') ?? '')) ??
                            'Unknown',
                        image: (massage['class'] == 'set'
                            ? (massage['ms_image_names'] is List
                                    ? (massage['ms_image_names']
                                        as List<dynamic>)
                                    : [massage['ms_image_names']])
                                .firstWhere(
                                (imageUrl) => imageUrl.isNotEmpty,
                                orElse: () =>
                                    'https://via.placeholder.com/290x140',
                              )
                            : massage['mt_image_name'] ??
                                'https://via.placeholder.com/290x140'),
                        isSet: massage['class'] == 'set',
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'เพิ่งดูไปล่าสุด',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        List.generate(5, (index) => _buildRecentlyViewedCard()),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/learn');
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'ท่านวดทั้งหมด',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/learn');
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'ดูทั้งหมด',
                          style: TextStyle(
                            color: Color(0xFFB1B1B1),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: [
                //     MassageCard(
                //       image: 'https://picsum.photos/seed/459/600',
                //       name: 'Name Massage',
                //       detail:
                //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                //       type: 'Back',
                //       time: 5,
                //     ),
                //     MassageCard(
                //       image: 'https://picsum.photos/seed/459/600',
                //       name: 'Name Massage',
                //       detail:
                //           'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                //       type: 'Back',
                //       time: 5,
                //     ),
                //   ],
                // )
                Column(
                  children: massages.isNotEmpty
                      ? massages.take(4).map((massage) {
                          return MassageCard(
                            image: massage['mt_image_name'] ??
                                'https://via.placeholder.com/100',
                            name: massage['mt_name'] ?? 'Unknown Massage',
                            detail: massage['mt_detail'] ??
                                'No description available.',
                            type: massage['mt_type'] ?? 'Unknown Type',
                            time: massage['mt_time'] ?? 0,
                          );
                        }).toList()
                      : [
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No massages available.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          initialIndex: 0, // หน้าแรกเริ่มที่ Home
          onTap: (index) {},
        ),
      ),
    );
  }

  Widget _buildFilterButton(String type) {
    // Normalize both selectedType and type to lowercase for a case-insensitive comparison
    bool isSelected = selectedType.toLowerCase() == type.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType =
              type.toLowerCase(); // Ensure selectedType is stored in lowercase
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 5, // Width of the dot
              height: 5, // Height of the dot
              decoration: BoxDecoration(
                color: Color(0xFFC0A172),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentlyViewedCard() {
    return MassageCardLarge(
      name: 'Name Massage',
      type: 'Shoulder',
      score: '4.8 / 5.0', // Add the required argument 'score'
      image:
          'https://picsum.photos/seed/picsum/200/300', // Add the required argument 'image'
      isSet: false, // Set to false since it's a single image
    );
  }
}
