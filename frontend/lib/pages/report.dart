import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
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
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: TextField(
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
                      onPressed: () {
                        debugPrint('Send Report button pressed');
                      },
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
