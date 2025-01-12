import 'package:flutter/material.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/singledetail.dart';

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
      initialRoute: '/singledetail',
      routes: {
        '/home' : (context) => const Homepage(),
        '/profile' : (context) => const Profile(),
        '/singledetail': (context) => const SingleDetailWidget(),
      },
    );
  }
}