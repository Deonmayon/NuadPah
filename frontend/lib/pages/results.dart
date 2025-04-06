import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final String imageUrl;

  const ResultsPage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ แสดงภาพจาก URL
            Image.network(
              imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => Center(child: Text('โหลดภาพไม่สำเร็จ')),
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
