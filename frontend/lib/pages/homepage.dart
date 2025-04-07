import 'package:flutter/material.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardLarge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth.dart';
import '../../api/massage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

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

  String selectedType = 'ท่านวดทั้งหมด';

  late Map<String, dynamic> userData = {
    'email': '',
    'firstname': '',
    'lastname': '',
    'image_name': '',
    'role': '',
  };

  // Thai type mapping to API types (lowercase)
  Map<String, String> thaiToApiTypeMapping = {
    'ท่านวดทั้งหมด': 'all',
    'หลัง': 'back',
    'บ่า ไหล่': 'shoulder',
    'ไหล่': 'shoulder',
    'แขน': 'arm',
    'ขา': 'leg',
    'คอ': 'neck',
  };

  // Cache variables
  List<dynamic>? _cachedRecMassages;
  List<dynamic>? _cachedAllMassages;
  Map<String, dynamic>? _cachedUserData;
  DateTime? _lastCacheTime;

  // Filtered massages for the current selection
  List<dynamic> _filteredMassages = [];

  @override
  void initState() {
    super.initState();
    // Force immediate data loading when homepage is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  Future<void> loadData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    // Clear any existing cache to ensure fresh data after sign-in
    _lastCacheTime = null;
    _cachedRecMassages = null;
    _cachedAllMassages = null;
    _cachedUserData = null;

    // Load data from SharedPreferences to start with
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userEmail = prefs.getString('userEmail') ?? '';

    // Set email in userData immediately to ensure it's available for API calls
    setState(() {
      userData['email'] = userEmail;
    });

    final cachedUserString = prefs.getString('userData');

    if (cachedUserString != null) {
      try {
        final Map<String, dynamic> cachedUser =
            Map<String, dynamic>.from(await jsonDecode(cachedUserString));
        setState(() {
          userData = cachedUser;
        });
      } catch (e) {
        print("Error parsing cached user data: $e");
      }
    }

    if (token == null) {
      print("Token is null, user not logged in.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Fetch all data in parallel
    try {
      final results = await Future.wait([
        _fetchUserData(token),
        _fetchRecMassages(userData['email'].toString()),
        _fetchAllMassages(),
      ]);

      // Cache time for future reference
      _lastCacheTime = DateTime.now();

      // Update state with fetched data
      setState(() {
        _updateFilteredMassages(); // Call filtering here to ensure it uses updated data
        isLoading = false;
      });
    } catch (e) {
      print("Error during parallel data loading: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData(String token) async {
    if (token.isEmpty) return;

    final apiService = AuthApiService();
    try {
      final response = await apiService.getUserData(token);
      if (response.data != null && response.data['email'] != null) {
        setState(() {
          userData = response.data;
          _cachedUserData = response.data;
        });

        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(userData));
      }
    } catch (e) {
      print("Error fetching user: ${e.toString()}");
    }
  }

  Future<void> _fetchRecMassages(String userEmail) async {
    if (userEmail.isEmpty) {
      print("Warning: Empty userEmail, trying to get from SharedPreferences");
      final prefs = await SharedPreferences.getInstance();
      userEmail = prefs.getString('userEmail') ?? '';
      if (userEmail.isEmpty) {
        print("Error: No user email available for recommendations");
        return;
      }
    }

    final apiService = MassageApiService();
    try {
      print("Fetching recommendations for email: $userEmail");
      final response = await apiService.getReccomendMassages(userEmail);
      List<Map<String, dynamic>> mappedMassage = (response.data as List)
          .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
          .toList();

      setState(() {
        recmassages = mappedMassage;
        _cachedRecMassages = mappedMassage;
        _updateFilteredMassages(); // Update filtered massages when recmassages changes
      });
    } catch (e) {
      print("Error fetching recommend massages: ${e.toString()}");
    }
  }

  Future<void> _fetchAllMassages() async {
    final apiService = MassageApiService();
    try {
      final response = await apiService.getAllMassages();
      setState(() {
        massages = response.data as List;
        _cachedAllMassages = response.data as List;
      });
    } catch (e) {
      print("Error fetching all massages: ${e.toString()}");
    }
  }

  void _updateFilteredMassages() {
    if (selectedType == 'ท่านวดทั้งหมด') {
      _filteredMassages = List.from(recmassages);
      return;
    }

    if (recmassages.isEmpty) {
      _filteredMassages = [];
      return;
    }

    _filteredMassages = recmassages.where((massage) {
      // For single massage types
      if (massage['class'] == 'single' && massage['mt_type'] != null) {
        return massage['mt_type'] == selectedType ||
            (selectedType == 'ไหล่' && massage['mt_type'] == 'บ่า ไหล่');
      }
      // For massage sets
      if (massage['class'] == 'set' && massage['ms_types'] != null) {
        List<dynamic> types = massage['ms_types'];
        for (var type in types) {
          if (type == selectedType ||
              (selectedType == 'ไหล่' && type == 'บ่า ไหล่')) {
            return true;
          }
        }
        return false;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Make sure _filteredMassages is initialized
    if (_filteredMassages.isEmpty && recmassages.isNotEmpty) {
      _updateFilteredMassages();
    }

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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFC0A172)),
                            ),
                          ),
                        ),
                      )
                    : ClipOval(
                        child: userData['image_name'] != null &&
                                userData['image_name'].toString().isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: '${userData['image_name']}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFC0A172)),
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/images/default_profile.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                'assets/images/default_profile.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => loadData(),
            color: Color(0xFFC0A172),
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
                        _buildFilterButton('ขา'),
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFC0A172)),
                            ),
                          )
                        : (_filteredMassages.isEmpty
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
                                itemCount: _filteredMassages.length,
                                itemBuilder: (context, index) {
                                  final massage = _filteredMassages[index];

                                  return MassageCardLarge(
                                    name: massage['name'] ?? 'Unknown Name',
                                    rating: massage['avg_rating']?.toString() ??
                                        'N/A',
                                    type: (massage['mt_type'] ??
                                            (massage['ms_types']?.join(', ') ??
                                                '')) ??
                                        'Unknown',
                                    image: massage['class'] == 'single'
                                        ? massage['mt_image_name'] ??
                                            'https://picsum.photos/seed/picsum/200/300'
                                        : (massage['ms_image_names'] != null &&
                                                massage['ms_image_names']
                                                    .isNotEmpty
                                            ? massage['ms_image_names'][0]
                                            : 'https://picsum.photos/seed/picsum/200/300'),
                                    isSet: massage['class'] == 'set',
                                    massageID: massage['class'] == 'single'
                                        ? massage['mt_id']?.toInt()
                                        : massage['ms_id']?.toInt(),
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFC0A172)),
                              ),
                            ),
                          ]
                        : (massages.isNotEmpty
                            ? massages.take(4).map((massage) {
                                return MassageCard(
                                  mtID: massage['mt_id'],
                                  image: massage['mt_image_name'],
                                  name: massage['mt_name'] ?? 'Unknown Massage',
                                  detail: massage['mt_detail'] ??
                                      'No description available.',
                                  type: massage['mt_type'] ?? 'Unknown Type',
                                  time: massage['mt_time'] ?? 0,
                                  rating: massage['avg_rating']?.toString() ??
                                      'N/A',
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
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ),
                              ]),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: HomeBottomNavigationBar(
          initialIndex: 0,
          onTap: (index) {},
        ),
      ),
    );
  }

  Widget _buildFilterButton(String thaiType) {
    bool isSelected = selectedType == thaiType;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = thaiType;
          _updateFilteredMassages();
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
}
