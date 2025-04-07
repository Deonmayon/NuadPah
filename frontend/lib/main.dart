import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:frontend/pages/singleMassageDetail.dart';
import 'package:frontend/pages/profile.dart';
import 'package:frontend/pages/forgetpassword/reset.dart';
import 'package:frontend/pages/forgetpassword/forget.dart';
import 'package:frontend/pages/forgetpassword/otp.dart';
import 'package:frontend/pages/signup.dart';
import 'package:frontend/pages/signin.dart';
import 'package:frontend/pages/homepage2.dart';
import 'package:frontend/pages/favouritepage.dart';
import 'package:frontend/pages/learnpage.dart';
import 'package:frontend/pages/mappage.dart';
import 'package:frontend/pages/cammassage.dart';
import 'package:frontend/pages/accountdetails.dart';
import 'package:frontend/pages/report.dart';
import 'package:frontend/pages/help.dart';
import 'package:frontend/pages/setMassageDetail.dart';
import 'utils/favorite_manager.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cameras before runApp
  cameras = await availableCameras();

  cameras = await availableCameras();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  FlutterError.onError = (FlutterErrorDetails details) {
    print(
        "Flutter Error: ${details.exceptionAsString()}"); // Only print error message
  };

  // Initialize the favorite manager at app startup
  await FavoriteManager.instance.init();

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
        fontFamily: 'Prompt',
        textTheme: TextTheme(
          bodyLarge:
              TextStyle(fontWeight: FontWeight.w400), // Regular (ข้อความใหญ่)
          bodyMedium:
              TextStyle(fontWeight: FontWeight.w300), // Light (ข้อความปกติ)
          bodySmall: TextStyle(
              fontWeight: FontWeight.w200), // ExtraLight (ข้อความเล็ก)

          titleLarge: TextStyle(fontWeight: FontWeight.w700), // Bold
          titleMedium: TextStyle(fontWeight: FontWeight.w600), // SemiBold
          titleSmall: TextStyle(fontWeight: FontWeight.w500), // Medium

          displayLarge: TextStyle(fontWeight: FontWeight.w100), // Thin
          displayMedium: TextStyle(fontWeight: FontWeight.w200), // ExtraLight
          displaySmall: TextStyle(fontWeight: FontWeight.w800), // ExtraBold

          headlineLarge: TextStyle(fontWeight: FontWeight.w900), // Black
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const SignInPage(),
        '/register': (context) => const SignUpPage(),
        '/forget': (context) => const ForgetPage(),
        '/otp': (context) => const OTPPage(
              email: '',
            ),
        '/reset': (context) => const ResetPage(
              email: '',
            ),
        '/home': (context) => const HomepageWidget(),
        '/profile': (context) => const ProfilePage(),
        '/accountdetails': (context) => const AccountdetailsPage(),
        '/singledetail': (context) => const SingleMassageDetailPage(),
        '/setdetail': (context) => const SetMassageDetailPage(),
        '/report': (context) => const ReportPage(),
        '/help': (context) => const HelpPage(),
        '/favourite': (context) => const Favouritepage(),
        '/learn': (context) => const LearnPage(),
        '/map': (context) => MapPage(),
        '/cam': (context) => LandscapePage(cameras: cameras),
      },
    );
  }
}
