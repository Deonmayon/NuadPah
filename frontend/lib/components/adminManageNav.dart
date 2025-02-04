import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminManageNav extends StatefulWidget {
  const AdminManageNav({Key? key}) : super(key: key);

  @override
  State<AdminManageNav> createState() => _AdminManageNavState();
}

class _AdminManageNavState extends State<AdminManageNav> {
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
            child: SizedBox(
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    _buildManageColumn1(
                      title1: 'User Manage',
                      title2: 'Report Manage',
                    ),
                    _buildManageColumn2(
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

  Widget _buildManageColumn1({required String title1, required String title2}) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildManageRow1(title1),
                _buildManageRow1(title2),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildManageColumn2({required String title1, required String title2}) {
    return Column(
      children: [
        Flexible(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildManageRow2(title1),
                _buildManageRow2(title2),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildManageRow1(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 146,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
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
              FaIcon(
                FontAwesomeIcons.chevronRight,
                color: Colors.white,
                size: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManageRow2(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
          child: Row(
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
              SizedBox(
                width: 20,
              ),
              FaIcon(
                FontAwesomeIcons.chevronRight,
                color: Colors.white,
                size: 10,
              ),
            ],
          ), 
        )
      ],
    );
  }
}
