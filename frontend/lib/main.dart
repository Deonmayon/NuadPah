import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

import 'package:frontend/pages/homepage.dart';
import 'package:frontend/pages/singleMassageDetail.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/welcome.dart';
import 'package:frontend/pages/forgetpassword/reset.dart';
import 'package:frontend/pages/forgetpassword/forget.dart';
import 'package:frontend/pages/forgetpassword/otp.dart';
import 'package:frontend/pages/signup.dart';
import 'package:frontend/pages/signin.dart';
import 'package:frontend/pages/setofMassageManage.dart';
import 'package:frontend/pages/homepage2.dart';
import 'package:frontend/pages/favouritepage.dart';
import 'package:frontend/pages/learnpage.dart';
import 'package:frontend/pages/mappage.dart';
import 'package:frontend/pages/cammassage.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cameras before runApp
  cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

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
      initialRoute: '/signin',
      routes: {
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/forget': (context) => const ForgetPage(),
        '/otp': (context) => const OTPPage(
              email: '',
            ),
        '/reset': (context) => const ResetPage(
              email: '',
            ),
        '/home': (context) => const HomepageWidget(
              email: '',
            ),
        '/profile': (context) => const ProfilePage(),
        '/singledetail': (context) => const SingleMassageDetailPage(),
        '/favourite': (context) => const Favouritepage(),
        '/learn': (context) => const LearnPage(),
        '/map': (context) => MapPage(),
        '/cam': (context) => LandscapePage(cameras: cameras),
      },
    );
  }
}
