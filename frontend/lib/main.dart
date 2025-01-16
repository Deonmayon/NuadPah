import 'package:flutter/material.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/singleMassageDetail.dart';
import 'package:frontend/pages/profile2.dart';
import 'package:frontend/pages/singleMassageManage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NuadPah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/singlemanage',
      routes: {
        '/home' : (context) => const Homepage(),
        '/profile' : (context) => const Profile(),
        '/profile2' : (context) => const ProfileWidget(),
        '/singledetail': (context) => const SingleDetailWidget(),
        '/singlemanage' : (context) => const SingleManageWidget(),
      },
    );
  }
}