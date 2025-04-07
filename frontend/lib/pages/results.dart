import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  final String imageUrl;

  const ResultsPage({super.key, required this.imageUrl});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int _selectedStars = 0;

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setState) {
            return AlertDialog(
              title: Text("คะแนนและความคิดเห็น"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _selectedStars
                              ? Icons.star
                              : Icons.star_border,
                          color: Color(0xFFC0A172),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedStars = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "แบ่งปันความคิดเห็นของคุณ",
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('ยกเลิก'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    _showRetryDialog();
                  },
                ),
                TextButton(
                  child: Text('ยืนยัน'),
                  onPressed: () {
                    print("User rated: $_selectedStars stars");
                    Navigator.of(dialogContext).pop();
                    _showRetryDialog();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("พร้อมที่จะเริ่มใหม่หรือยัง?"),
          content: Text("แตะที่ปุ่ม 'เริ่มใหม่' เพื่อเริ่มเกมใหม่"),
          actions: <Widget>[
            TextButton(
              child: Text('ไม่'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('เริ่มใหม่'),
              onPressed: () {
                // ใส่ logic สำหรับเริ่มใหม่ที่นี่
                Navigator.of(dialogContext).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) =>
                  Center(child: Text('โหลดภาพไม่สำเร็จ')),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, left: 20),
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
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'คุณต้องการรีวิวหรือไม่?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC0A172),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // กลับหน้าเดิม
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5757),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ไม่',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showReviewDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC0A172),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'ใช่',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
