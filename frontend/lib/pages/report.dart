import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  late Map<String, dynamic> userData = {
    'email': '',
    'firstname': '',
    'lastname': '',
    'image_name': '',
    'role': '',
  };

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    await getUserEmail();
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token is null, user not logged in.");
      return;
    }

    try {
      final response = await apiService.getUserData(token);

      print("User data: ${response.data}"); // Debugging line

      setState(() {
        userData = response.data;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> _sendReport() async {
    final apiService = AuthApiService();
    try {
      await apiService.sendReport(
        userData['email'],
        _titleController.text,
        _detailController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ส่งรายงานสำเร็จ')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
      );
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
              'แจ้งปัญหา',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                'หัวข้อปัญหา*:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'กรุณาระบุหัวข้อปัญหา',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, left: 20),
              child: Text(
                'อธิบายปัญหาของคุณ*:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 20),
              child: Text(
                '1.คุณพบปัญหาอะไร?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1, left: 20),
              child: Text(
                '2.คุณพบปัญหานี้เมื่อไหร่?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 1, left: 20),
              child: Text(
                '3.คุณพบปัญหานี้ที่ส่วนไหน?',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
                controller: _detailController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'กรุณาอธิบายปัญหาของคุณ',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // จัดให้อยู่กลางในแนวนอน
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: 372,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(192, 161, 114, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _sendReport,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ส่งข้อมูล',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
