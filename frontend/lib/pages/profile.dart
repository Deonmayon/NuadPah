import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/components/profileFunctionBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  bool isLoading = true;

  late Map<String, dynamic> userData = {
    'email': '',
    'firstname': '',
    'lastname': '',
    'image_name': '',
    'role': '',
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true; // Set loading state to true before fetching
    });

    await getUserEmail();

    setState(() {
      isLoading = false; // Set loading state to false after all data is fetched
    });
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      debugPrint("Token is null, user not logged in.");
      return;
    }

    try {
      final response = await apiService.getUserData(token);

      if (response.data == null || response.data['email'] == null) {
        throw Exception('Invalid user data received');
      }

      setState(() {
        userData = response.data;
      });
    } catch (e) {
      setState(() {
        debugPrint(
            "Error fetching user: ${e.toString()}"); // Only prints error message
      });
    }
  }

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
              'โปรไฟล์',
              style: TextStyle(
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
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  radius: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                  ),
                ),
              )
            else
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('${userData['image_name']}'),
                  // backgroundImage: NetworkImage('https://picsum.photos/seed/picsum/200/300'),
                ),
              ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC0A172)),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  '${userData['firstname']} ${userData['lastname']}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'โปรไฟล์',
                  style: TextStyle(
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            ProfileFunctionBar(
              icon: Icons.person,
              title: 'รายละเอียดบัญชี',
              path: '/accountdetails',
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'เกี่ยวกับ',
                  style: TextStyle(
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            ProfileFunctionBar(
              icon: Icons.report_problem,
              title: 'แจ้งปัญหา',
              path: '/report',
            ),
            const SizedBox(height: 10),
            ProfileFunctionBar(
              icon: Icons.help_outline,
              title: 'ช่วยเหลือ',
              path: '/help',
            ),
            const SizedBox(height: 10),
            ProfileFunctionBar(
              icon: Icons.logout,
              title: 'ลงชื่อออก',
              showArrow: false,
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
