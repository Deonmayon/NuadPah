import 'package:flutter/material.dart';
import '/pages/forgetpassword/otp.dart';
import '/components/emailtextfield.dart';
import '/components/submitbox.dart';
import '../../api/auth.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final TextEditingController _emailController = TextEditingController();
  String _errorMessage = '';

  Future<void> _sendotp() async {
    final apiService = AuthApiService();

    try {
      final response = await apiService.sendOTP(
        _emailController.text,
      );

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTPPage(email: _emailController.text)),
        );
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'ไม่พบอีเมลนี้ในระบบ';
        });
      } else {
        setState(() {
          _errorMessage = 'การส่งรหัส OTP ล้มเหลว';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC0A172), // Tan background color
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Welcome Text
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'ลืมรหัสผ่าน?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // White Container with Curved Top
              Positioned(
                top: 240,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),

                  // Before Input Fields
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 30, right: 30, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'กรุณากรอกอีเมลที่ลงทะเบียนไว้',
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xFFBFAB93),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'เราจะส่งรหัส OTP ไปยังอีเมลของคุณ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF676767),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

                        // Email TextField
                        EmailTextField(
                          controller: _emailController,
                          hintText: 'อีเมล',
                        ),
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        SizedBox(height: 40),

                        // Sign In Button
                        SizedBox(height: 20),
                        SubmitBox(
                          buttonText: 'ส่งรหัส OTP',
                          onPress: _sendotp,
                          showArrow: true,
                        ),

                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
