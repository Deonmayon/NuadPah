import 'package:flutter/material.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/massagecardSmall.dart';
import 'package:frontend/components/massagecardLarge.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/massage.dart';

class HomepageWidget extends StatefulWidget {
  final String email;

  const HomepageWidget({Key? key, required this.email}) : super(key: key);

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _errorMessage = '';

  List<dynamic> recmassages = [];

  String selectedType = 'All massages';

  @override
  void initState() {
    super.initState();
    Future.wait([fetchMassages()]);
  }

  Future<void> fetchMassages() async {
    final apiService = ApiService(baseUrl: 'http://10.0.2.2:3001');

    try {
      final response = await apiService.getReccomendMassages(widget.email);
      print("API response: ${response.data}");

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

  // final List<Map<String, String>> massages = [
  //   {'type': 'Back', 'name': 'Relaxing Back Massage'},
  //   {'type': 'Arms', 'name': 'Arm Soothing Massage'},
  //   {'type': 'Legs', 'name': 'Leg Comfort Massage'},
  //   {'type': 'Neck', 'name': 'Neck Pain Relief'},
  //   {'type': 'Back', 'name': 'Deep Tissue Back Massage'},
  // ];

  @override
  Widget build(BuildContext context) {
    print("---------------------------------------------------");
    print("massages response: ${recmassages}");
    final filteredMassages = selectedType == 'All massages'
        ? recmassages
        : recmassages
            .where((massages) => massages['mt_type'] == selectedType)
            .toList();

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
                    'Hello, Esther',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Welcome to Nuadpah',
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
                    'Recommend',
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
                      _buildFilterButton('Arms'),
                      SizedBox(
                        width: 20,
                      ),
                      _buildFilterButton('Legs'),
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
                        score: massage['score']?.toString() ?? 'N/A',
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
                    'Recently viewed',
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
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'All Massages',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          color: Color(0xFFB1B1B1),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    MassageCard(
                      image: 'https://picsum.photos/seed/459/600',
                      name: 'Name Massage',
                      detail:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      type: 'Back',
                      time: '5 minutes',
                    ),
                    MassageCard(
                      image: 'https://picsum.photos/seed/459/600',
                      name: 'Name Massage',
                      detail:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      type: 'Back',
                      time: '5 minutes',
                    ),
                    MassageCard(
                      image: 'https://picsum.photos/seed/459/600',
                      name: 'Name Massage',
                      detail:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      type: 'Back',
                      time: '5 minutes',
                    ),
                  ],
                )
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
    bool isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = type;
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
              width: 5, // ความกว้างของจุด
              height: 5, // ความสูงของจุด
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
