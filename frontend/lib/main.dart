import 'package:flutter/material.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/singleMassageDetail.dart';
import 'package:frontend/pages/profile2.dart';
import 'package:frontend/pages/singleMassageManage.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/pages/forgetpassword/reset.dart';
import 'package:frontend/pages/forgetpassword/forget.dart';
import 'package:frontend/pages/forgetpassword/otp.dart';
import 'package:frontend/pages/register.dart';
import 'package:frontend/pages/login.dart';

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
      initialRoute: '/login',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login' : (context) => const LoginPage(),
        '/register' : (context) => const RegisterPage(),
        '/forget' : (context) => const ForgetPage(),
        '/otp' : (context) => const OTPPage(),
        '/reset' : (context) => const ResetPage(),
        '/home' : (context) => const Homepage(),
        '/profile' : (context) => const Profile(),
        '/profile2' : (context) => const ProfileWidget(),
        '/singledetail': (context) => const SingleDetailWidget(),
        '/singlemanage' : (context) => const SingleManageWidget(),
      },
    );
  }
}