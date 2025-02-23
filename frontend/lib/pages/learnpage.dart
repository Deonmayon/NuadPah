import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';

class Learnpage extends StatefulWidget {
  const Learnpage({Key? key}) : super(key: key);

  @override
  State<Learnpage> createState() => _LearnState();
}

class _LearnState extends State<Learnpage> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();
  int _selectedTab = 0; // 0: Single Massage, 1: Set of Massage

  final List<Widget> _tabsContent = [
    SingleMassageTab(),
    SetOfMassageTab(),
  ];

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
              'Learn',
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  _buildTabButton('Single Massage', 0),
                  _buildTabButton('Set of Massage', 1),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Container(
                width: 372,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 15,
                      color: Color(0x3F000000),
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: Color(0xFFB1B1B1),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: textController,
                          focusNode: textFieldFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                              fontFamily: 'Roboto',
                              color: Color(0xFFB1B1B1),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC0A172),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.list,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _tabsContent[_selectedTab],
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigationBar(
        initialIndex: 1, // หน้าแรกเริ่มที่ Home
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
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: 4,
      itemBuilder: (context, index) {
        return MassageCard(
          title: 'Name Massage',
          description: 'Lorem ipsum dolor sit amet,fdfgdfgfgg fgfconsectetur adipiscing elit, sed ghg cvdffgvbd dfdsfsfnf fgfgdgdhd...',
          type: 'Type: Back',
          duration: '≈ 5 minutes',
          imageUrl: 'assets/images/Massage_Image11.png',
        );
      },
    );
  }
}

class SetOfMassageTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return MassageCardSet(
          title: 'Name Set of Massage',
          description: 'Lorem ipsum dolor sit amet,fdfgdfgfgg fgfconsectetur adipiscing elit, sed ghg cvdffgvbd dfdsfsfnf fgfgdgdhd...',
          type: 'Type: Back, Shoulder, Neck',
          duration: '≈ 15 minutes',
          imageUrl1: 'assets/images/Massage_Image01.png',
          imageUrl2: 'assets/images/Massage_Image03.png',
          imageUrl3: 'assets/images/Massage_Image11.png',
        );
      },
    );
  }
}

class MassageCard extends StatelessWidget {
  final String title;
  final String description;
  final String type;
  final String duration;
  final String imageUrl;

  const MassageCard({
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
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
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          type,
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
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          duration,
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
                  borderRadius:
                      BorderRadius.circular(10), // ทำให้เป็นสี่เหลี่ยม
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
    );
  }
}


class MassageCardSet extends StatelessWidget {
  final String title;
  final String description;
  final String type;
  final String duration;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;

  const MassageCardSet({
    required this.title,
    required this.description,
    required this.type,
    required this.duration,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.imageUrl3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      width: double.infinity,
      height: 180,
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
            child: Container(
              width: 130,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        child: Image.asset(
                          imageUrl1,
                          width: 65,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
                        child: Image.asset(
                          imageUrl2,
                          width: 65,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        imageUrl3,
                        width: 130,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            )
          ),
          
        
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                    ),
                  ),
                  
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft, // จัดให้อยู่ด้านซ้าย
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBDBDB),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            duration,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft, // จัดให้อยู่ด้านซ้าย
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBDBDB),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            type,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black,
                            ),
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
                  borderRadius:
                      BorderRadius.circular(10), // ทำให้เป็นสี่เหลี่ยม
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
    );
  }
}