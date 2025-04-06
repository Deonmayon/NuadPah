import 'dart:io';
import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String imagePath;

  const ResultsPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ แสดงรูปจาก path ที่ส่งมา
            Image.file(
              File(imagePath),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // ✅ ปุ่มย้อนกลับ
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: CircleAvatar(
                  backgroundColor: Color(0xB3C0A172),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
