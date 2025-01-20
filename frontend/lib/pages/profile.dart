import 'package:flutter/material.dart';
import 'package:frontend/components/profileFunctionBar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatelessWidget {
  final String profileImage = 'assets/images/profilePicture.jpg';

  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
                const SizedBox(width: 40), // Center the app bar by adding an additional box
              ],
            ),
          ),
          Container(
            height: 1,
            color: const Color.fromRGBO(219, 219, 219, 1),
            width: double.infinity, 
          ),

          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(219, 219, 219, 1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profileImage),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Esther Howard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.w800,
                        color: Color.fromRGBO(177, 177, 177, 1),
                      ),
                    ),
                  ),
                  ProfileFunctionBar(
                    icon: Icons.person,
                    title: 'Account details',
                  ),
                  SizedBox(height: 10),
                  ProfileFunctionBar(
                    icon: Icons.lock,
                    title: 'Privacy',
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10), 
                    child: Text(
                      'About',
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: FontWeight.w800,
                        color: Color.fromRGBO(177, 177, 177, 1),
                      ),
                    ),
                  ),
                  ProfileFunctionBar(
                    icon: Icons.report_problem,
                    title: 'Report',
                  ),
                  SizedBox(height: 10),
                  ProfileFunctionBar(
                    icon: Icons.help_outline,
                    title: 'Help',
                  ),
                  SizedBox(height: 10),
                  ProfileFunctionBar(
                    icon: Icons.logout,
                    title: 'Logout',
                    showArrow: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
