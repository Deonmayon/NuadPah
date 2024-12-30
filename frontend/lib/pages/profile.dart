import 'package:flutter/material.dart';
import 'package:frontend/components/profileFunctionBar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          iconSize: 40,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        toolbarHeight: 70,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center content horizontally
        children: [
          ProfileFunctionBar(
            icon: Icons.person,
            title: 'Account details',
          ),
          SizedBox(height: 10),
          ProfileFunctionBar(
            icon: Icons.lock,
            title: 'Privacy',
          ),
          SizedBox(height: 10),
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
            showArrow: false, // Hide the arrow for Logout
          ),
        ],
      )),
    );
  }
}
