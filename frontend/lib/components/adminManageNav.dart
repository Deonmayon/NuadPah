import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavManageWidget extends StatefulWidget {
  const NavManageWidget({Key? key}) : super(key: key);

  @override
  State<NavManageWidget> createState() => _NavManageWidgetState();
}

class _NavManageWidgetState extends State<NavManageWidget> {
  bool isNavAdminManageVisible = false; // สถานะสำหรับแสดง/ซ่อนส่วน Admin

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(minHeight: 50),
      decoration: const BoxDecoration(
        color: Color(0xFFC0A172),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Single Massage Manage',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    icon: FaIcon(
                      isNavAdminManageVisible
                          ? FontAwesomeIcons.xmark
                          : FontAwesomeIcons.bars,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      setState(() {
                        isNavAdminManageVisible = !isNavAdminManageVisible;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isNavAdminManageVisible)
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildManageColumn(
                      title1: 'User Manage',
                      title2: 'Report Manage',  
                    ),
                    const SizedBox(width: 15),
                    _buildManageColumn(
                      title1: 'Single Massage Manage',
                      title2: 'Set of Massage Manage',
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildManageColumn({required String title1, required String title2}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildManageRow(title1),
            _buildManageRow(title2),
          ],
        ),
      ),
    );
  }

  Widget _buildManageRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronRight,
            color: Colors.white,
            size: 10,
          ),
          onPressed: () {
            debugPrint('$title button pressed');
          },
        ),
      ],
    );
  }
}
