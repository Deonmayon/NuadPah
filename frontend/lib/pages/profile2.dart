import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/profileFunctionBar.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool isAdmin = true; // สถานะสำหรับตรวจสอบ Admin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft,
                  color: Colors.black, size: 25),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Text(
              'Profile',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 30),
          ],
        ),
        elevation: 1,
        toolbarHeight: 70,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://picsum.photos/seed/5/600'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Esther Howard',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const ProfileFunctionBar(
              icon: Icons.person,
              title: 'Account details',
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About',
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const ProfileFunctionBar(
              icon: Icons.report_problem,
              title: 'Report',
            ),
            const SizedBox(height: 10),
            const ProfileFunctionBar(
              icon: Icons.help_outline,
              title: 'Help',
            ),
            const SizedBox(height: 10),
            const ProfileFunctionBar(
              icon: Icons.logout,
              title: 'Logout',
              showArrow: false,
            ),

            // แสดงข้อมูลสำหรับ Admin เท่านั้น
            if (isAdmin)
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (isAdmin)
              const SizedBox(height: 10),
              const ProfileFunctionBar(
                icon: Icons.help_outline,
                title: 'Admin',
              ),
          ],
        ),
      ),
    );
  }
}
