import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/pages/homepage.dart';
import 'signin.dart';
import '/components/emailtextfield.dart';
import '/components/passwordfield.dart';
import '/components/submitbox.dart';
import '../api/auth.dart'; // Import the ApiService class
import 'package:shared_preferences/shared_preferences.dart'; // like localStorage but in flutter

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isObscured = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _signup() async {
    final RegExp gmailRegex = RegExp(r'^[a-zA-Z0-9._]+@gmail\.com$');
    // final RegExp passwordRegex = RegExp(r'^[a-zA-Z0-9]$');

    if (!gmailRegex.hasMatch(_emailController.text)) {
      setState(() {
        _errorMessage = 'กรุณาใช้อีเมล Gmail ที่ถูกต้อง';
      });
      return;
    }

    // if (!passwordRegex.hasMatch(_passwordController.text)) {
    //   setState(() {
    //     _errorMessage = 'กรุณากรอกอักษรภาษาอังกฤษ ตัวเลข';
    //   });
    //   return;
    // }

    if (_passwordController.text.length < 8 ||
        _passwordController.text.length > 20) {
      setState(() {
        _errorMessage = 'กรุณากรอกรหัสผ่าน 8-20 ตัวอักษร';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final apiService = AuthApiService();

    try {
      final response = await apiService.signUp(
        _emailController.text,
        _passwordController.text,
        _firstnameController.text,
        _lastnameController.text,
      );

      if (response.statusCode == 201) {
        // pull token from response and set token (like localStorage)
        final token = response.data;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Use a timeout to limit validation time
        try {
          // Set a 1.5-second timeout for the validation
          bool completed = false;

          await Future.any([
            apiService.getUserData(token).then((userDataResponse) {
              if (userDataResponse.statusCode == 200 && !completed) {
                completed = true;
                setState(() => _isLoading = false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomepageWidget()),
                );
              }
            }),
            Future.delayed(Duration(milliseconds: 1500)).then((_) {
              if (!completed) {
                throw Exception('Validation timed out');
              }
            })
          ]);
        } catch (e) {
          // If timeout or error occurs during validation, go to sign in
          setState(() => _isLoading = false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Registration failed';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _gotoSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInPage()),
    );
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
                    'เริ่มกันเลย!',
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
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 30, right: 30, bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'ลงทะเบียน',
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xFFBFAB93),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

                        // Row with First Name and Last Name TextFields
                        Row(
                          children: [
                            Expanded(
                              child: EmailTextField(
                                controller: _firstnameController,
                                hintText: 'ชื่อ',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: EmailTextField(
                                controller: _lastnameController,
                                hintText: 'นามสกุล',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Email TextField
                        EmailTextField(
                          controller: _emailController,
                          hintText: 'อีเมล',
                        ),
                        SizedBox(height: 20),

                        // Password TextField
                        PasswordField(
                          controller: _passwordController,
                          hintText: 'รหัสผ่าน',
                          isObscured: _isObscured,
                          onToggle: _togglePasswordVisibility,
                        ),
                        SizedBox(height: 20),

                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),

                        // Sign In Button with loading indicator
                        _isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFBFAB93)),
                              )
                            : SubmitBox(
                                buttonText: 'ลงทะเบียน',
                                onPress: _signup,
                                showArrow: true,
                              ),
                        SizedBox(height: 30),

                        // Create Account Link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "มีบัญชีแล้ว? ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'ลงชื่อเข้าใช้',
                                  style: TextStyle(
                                    color: Color(0xFFBFAB93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _gotoSignIn,
                                ),
                              ],
                            ),
                          ),
                        ),
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
