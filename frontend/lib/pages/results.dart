import 'package:flutter/material.dart';
import '../../api/auth.dart';
import '../../api/massage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultsPage extends StatefulWidget {
  final String imageUrl;
  final int? massageId; // Keep this parameter

  const ResultsPage({
    super.key, 
    required this.imageUrl,
    this.massageId, // Keep this parameter
  });

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  int _selectedStars = 0;

  Map<String, dynamic> userData = {
    'email': '',
    'first_name': '',
    'last_name': '',
    'image_name': '',
    'role': '',
  };

  // Update the getter to provide a default value if massageId is null

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    // First get user email (needed for subsequent queries)
    await getUserEmail();
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      if (token == null) throw Exception('Token not found');
      final response = await apiService.getUserData(token);
      setState(() {
        userData = response.data;
      });
    } catch (e) {
      setState(() {
        "Error fetching user data: ${e.toString()}";
      });
    }
  }

  Future<void> sendReview(String reviewText, int rating) async {
    final apiService = MassageApiService();

    try {
      // Use the massageId passed from previous screen
      DateTime now = DateTime.now();

      int massageId = 1; // Use the getter that provides the actual massageId

      final response = await apiService.reviewSingle(
        userData['email'],
        massageId, // Use the getter that provides the actual massageId
        reviewText,
        rating,
        now,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ส่งรีวิวสำเร็จแล้ว ขอบคุณสำหรับความคิดเห็น')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการส่งรีวิว: ${e.toString()}')),
      );
    }
  }

  void _showReviewDialog() {
    final TextEditingController reviewController = TextEditingController();

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
                    controller: reviewController,
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
                    // Call the sendReview method with the review text and rating
                    sendReview(reviewController.text, _selectedStars);
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
