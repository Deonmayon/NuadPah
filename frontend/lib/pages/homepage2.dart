import 'package:flutter/material.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardLarge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth.dart';
import '../../api/massage.dart';

class HomepageWidget extends StatefulWidget {

  const HomepageWidget({Key? key}) : super(key: key);

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<dynamic> recmassages = [];
  List<dynamic> massages = [];
  bool isLoading = true;

  String selectedType = 'all';  // Keep English internally

  late Map<String, dynamic> userData = {
    'email': '',
    'firstname': '',
    'lastname': '',
    'image_name': '',
    'role': '',
  };

  // Update mapping to use lowercase types as in API
  Map<String, String> typeMapping = {
    'all': 'ท่านวดทั้งหมด',
    'back': 'หลัง',
    'arm': 'แขน',
    'shoulder': 'ไหล่',
    'neck': 'คอ',
  };

  String getThaiType(String englishType) {
    return typeMapping[englishType] ?? englishType;
  }

  String getEnglishType(String thaiType) {
    return typeMapping.entries
        .firstWhere((entry) => entry.value == thaiType,
            orElse: () => MapEntry(thaiType, thaiType))
        .key;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true; // Set loading state to true before fetching
    });

    await getUserEmail();
    await fetchRecMassages();
    await fetchMassages();

    setState(() {
      isLoading = false; // Set loading state to false after all data is fetched
    });
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token is null, user not logged in.");
      return;
    }

    try {
      final response = await apiService.getUserData(token);

      if (response.data == null || response.data['email'] == null) {
        throw Exception('Invalid user data received');
      }

      setState(() {
        userData = response.data;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching user: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> fetchRecMassages() async {
    final apiService = MassageApiService();

    final userEmail = userData['email'].toString();

    try {
      final response = await apiService.getReccomendMassages(userEmail);

      List<Map<String, dynamic>> mappedMassage = (response.data as List)
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();

      setState(() {
        recmassages = mappedMassage;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching recommend massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> fetchMassages() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getAllMassages();

      setState(() {
        massages = response.data as List;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching all massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    print('UserData: $userData');
    print('Current selected type: $selectedType'); // Debug print
    
    final filteredMassages = selectedType == 'all'
        ? recmassages
        : recmassages.where((massage) {
            // For single massage types
            if (massage['mt_type'] != null) {
              return massage['mt_type'].toLowerCase() == selectedType.toLowerCase();
            }
            // For massage sets
            if (massage['ms_types'] != null) {
              return massage['ms_types'].contains(selectedType.toLowerCase());
            }
            return false;
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
                children: [
                  if (isLoading)
                  const SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                    ),
                  )
                else
                  Text(
                    'สวัสดี, ${userData['firstname'] ?? 'ผู้ใช้'}',
                    style: const TextStyle(
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
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: isLoading
                    ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                            ),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: Image.network(
                          '${userData['image_name']}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/default_profile.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
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
                      _buildFilterButton('ท่านวดทั้งหมด'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('หลัง'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('แขน'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('ไหล่'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('คอ'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: isLoading 
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                          ),
                        )
                      : (filteredMassages.isEmpty
                          ? Center(
                              child: Text(
                                'ไม่พบท่านวดในหมวดหมู่นี้',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : ListView.builder(
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
                                  image: massage['class'] == 'single' 
                                      ? massage['mt_image_name'] ?? 'https://picsum.photos/seed/picsum/200/300'
                                      : (massage['ms_image_names'] != null && massage['ms_image_names'].isNotEmpty
                                          ? massage['ms_image_names'][0]
                                          : 'https://picsum.photos/seed/picsum/200/300'),
                                  isSet: massage['class'] == 'set',
                                );
                              },
                            )),
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
                Column(
                  children: isLoading
                      ? [
                          Container(
                            height: 200,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                            ),
                          ),
                        ]
                      : (massages.isNotEmpty
                          ? massages.take(4).map((massage) {
                              return MassageCard(
                                mt_id: massage['mt_id'],
                                image: massage['mt_image_name'],
                                name: massage['mt_name'] ?? 'Unknown Massage',
                                detail: massage['mt_detail'] ??
                                    'No description available.',
                                type: massage['mt_type'] ?? 'Unknown Type',
                                time: massage['mt_time'] ?? 0,
                                onFavoriteChanged: (isFavorite) {
                                  print('Massage favorited: $isFavorite');
                                },
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
                            ]),
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

  Widget _buildFilterButton(String thaiType) {
    String engType = getEnglishType(thaiType);
    bool isSelected = selectedType == engType;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = engType;
          print('Selected type: $selectedType'); // Debug print
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            thaiType,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 5,
              height: 5,
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
      score: '4.8 / 5.0',
      image: 'https://picsum.photos/seed/picsum/200/300',
      isSet: false,
    );
  }
}
