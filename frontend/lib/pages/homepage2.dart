import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';

class HomepageWidget extends StatefulWidget {
  const HomepageWidget({Key? key}) : super(key: key);

  @override
  State<HomepageWidget> createState() => _HomepageWidgetState();
}

class _HomepageWidgetState extends State<HomepageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> massages = [
    {'type': 'Back', 'name': 'Relaxing Back Massage'},
    {'type': 'Arms', 'name': 'Arm Soothing Massage'},
    {'type': 'Legs', 'name': 'Leg Comfort Massage'},
    {'type': 'Neck', 'name': 'Neck Pain Relief'},
    {'type': 'Back', 'name': 'Deep Tissue Back Massage'},
  ];

  String selectedType = 'All massages';

  @override
  Widget build(BuildContext context) {
    final filteredMassages = selectedType == 'All massages'
        ? massages
        : massages.where((massage) => massage['type'] == selectedType).toList();

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
                      SizedBox(width: 20,),
                      _buildFilterButton('All massages'),
                      SizedBox(width: 20,),
                      _buildFilterButton('Back'),
                      SizedBox(width: 20,),
                      _buildFilterButton('Arms'),
                      SizedBox(width: 20,),
                      _buildFilterButton('Legs'),
                      SizedBox(width: 20,),
                      _buildFilterButton('Neck'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 280, // กำหนดพื้นที่ให้เหมาะสม
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredMassages.length,
                    itemBuilder: (context, index) {
                      return _buildRecommendationCard(filteredMassages[index]); 
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
                        List.generate(2, (index) => _buildRecentlyViewedCard()),
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
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Color(0x40000000),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/Massage_Image01.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name Massage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Lorem ipsum dolor sit amet,fdfgdfgfgg fgfconsectetur adipiscing elit, sed ghg cvdffgvbd dfdsfsfnf fgfgdgdhd...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB1B1B1),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBDBDB),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "Type : Back",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBDBDB),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "≈ 5 minutes",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                width: 30, // ความกว้างของปุ่ม
                                height: 30, // ความสูงของปุ่ม
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFDBDBDB), // พื้นหลังของปุ่ม
                                  borderRadius: BorderRadius.circular(
                                      10), // ทำให้เป็นสี่เหลี่ยม
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.solidBookmark,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Color(0x40000000),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/Massage_Image03.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name Massage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Lorem ipsum dolor sit amet,fdfgdfgfgg fgfconsectetur adipiscing elit, sed ghg cvdffgvbd dfdsfsfnf fgfgdgdhd...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB1B1B1),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBDBDB),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "Type : Back",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBDBDB),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "≈ 5 minutes",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                width: 30, // ความกว้างของปุ่ม
                                height: 30, // ความสูงของปุ่ม
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFDBDBDB), // พื้นหลังของปุ่ม
                                  borderRadius: BorderRadius.circular(
                                      10), // ทำให้เป็นสี่เหลี่ยม
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.solidBookmark,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Color(0x40000000),
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/Massage_Image11.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Name Massage',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Lorem ipsum dolor sit amet,fdfgdfgfgg fgfconsectetur adipiscing elit, sed ghg cvdffgvbd dfdsfsfnf fgfgdgdhd...',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB1B1B1),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBDBDB),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "Type : Back",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDBDBDB),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "≈ 5 minutes",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                width: 30, // ความกว้างของปุ่ม
                                height: 30, // ความสูงของปุ่ม
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFDBDBDB), // พื้นหลังของปุ่ม
                                  borderRadius: BorderRadius.circular(
                                      10), // ทำให้เป็นสี่เหลี่ยม
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  alignment: Alignment.center,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.solidBookmark,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
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

  Widget _buildRecommendationCard(Map<String, String> massage) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 290,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: const Color(0x40000000),
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 135,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      massage['image'] ?? 'assets/images/Massage_Image01.png',
                      width: 290,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0x99DBDBDB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        icon: const FaIcon(
                          FontAwesomeIcons.solidBookmark,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 15,
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12.5,
                            backgroundImage: AssetImage(
                              massage['avatar'] ??
                                  'assets/images/Massage_Image01.png',
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Type: ${massage['type'] ?? 'Unknown'}',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                massage['name'] ?? 'Unnamed Massage',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.solidClock,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    '≈ ${massage['duration'] ?? '15 mins'}',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.solidStar,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    '${massage['rating'] ?? '4.8/5.0'}',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyViewedCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 290,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: const Color(0x40000000),
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 135,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      'assets/images/Massage_Image11.png',
                      width: 290,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 35, // ความกว้างของปุ่ม
                      height: 35, // ความสูงของปุ่ม
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0x99DBDBDB), // พื้นหลังของปุ่ม
                        borderRadius:
                            BorderRadius.circular(10), // ทำให้เป็นสี่เหลี่ยม
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        icon: const FaIcon(
                          FontAwesomeIcons.solidBookmark,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 15,
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12.5,
                            backgroundImage: AssetImage(
                              'assets/images/Massage_Image03.png',
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Type: Shoulder',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Name Massage',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: const [
                  Icon(FontAwesomeIcons.solidClock,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    '≈ 15 mins',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.solidStar,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    '4.8/5.0',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
