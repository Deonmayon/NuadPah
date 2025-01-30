import 'package:flutter/material.dart';
import 'package:frontend/pages/singleMassageDetail.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/singleMassageManage.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/pages/forgetpassword/reset.dart';
import 'package:frontend/pages/forgetpassword/forget.dart';
import 'package:frontend/pages/forgetpassword/otp.dart';
import 'package:frontend/pages/signup.dart';
import 'package:frontend/pages/signin.dart';

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
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/forget': (context) => const ForgetPage(),
        '/otp': (context) => const OTPPage(email: ''),
        '/reset': (context) => const ResetPage(email: ''),
        '/home': (context) => const WelcomePage(),
        '/profile': (context) => const ProfilePage(),
        '/singledetail': (context) => const SingleMassageDetailPage(),
        '/singlemanage': (context) => const SingleMassageManagePage(),
      },
    );
  }
}
