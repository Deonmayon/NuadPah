import 'package:flutter/material.dart';
import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/singleMassageDetail.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/pages/forgetpassword/reset.dart';
import 'package:frontend/pages/forgetpassword/forget.dart';
import 'package:frontend/pages/forgetpassword/otp.dart';
import 'package:frontend/pages/register.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/homepage2.dart';
import 'package:frontend/pages/favouritepage.dart';
import 'package:frontend/pages/learnpage.dart';
import 'package:frontend/pages/mappage.dart';
import 'package:frontend/pages/cammassage.dart';
import 'package:camera/camera.dart'; 
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  if (Platform.isAndroid) {
    // Disable Impeller for Android
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<CameraDescription> _getFirstCamera() async {
    final cameras = await availableCameras();
    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NuadPah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/cam',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login' : (context) => const LoginPage(),
        '/register' : (context) => const RegisterPage(),
        '/forget' : (context) => const ForgetPage(),
        '/otp' : (context) => const OTPPage(),
        '/reset' : (context) => const ResetPage(),
        '/home' : (context) => const Homepage(),
        '/home2' : (context) => const HomepageWidget(),
        '/profile' : (context) => const ProfilePage(),
        '/singledetail': (context) => const SingleMassageDetailPage(),
        '/favourite' : (context) => const Favouritepage(),
        '/learn' : (context) => const LearnPage(),
        '/map' : (context) => MapPage(),
        '/cam': (context) => FutureBuilder<CameraDescription>(
          future: _getFirstCamera(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return LandscapePage(camera: snapshot.data!);
              } else {
                return Center(child: Text("No Camera Found"));
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      },
    );
  }
}