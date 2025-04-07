import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/pages/homepage2.dart';
import 'signin.dart';
import '/components/emailtextfield.dart';
import '/components/passwordfield.dart';
import '/components/submitbox.dart';
import '../api/auth.dart'; // Import the ApiService class
import 'package:shared_preferences/shared_preferences.dart'; // like localStorage but in flutter
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _signup() async {
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

        // Validate registration by making an explicit call to fetch user data
        try {
          // Increase delay to give backend more time to complete registration
          await Future.delayed(Duration(milliseconds: 1500));
          
          // Try to fetch user data multiple times with increasing delays
          bool userDataFetched = false;
          Exception? lastError;
          
          for (int attempt = 1; attempt <= 3 && !userDataFetched; attempt++) {
            try {
              final userDataResponse = await apiService.getUserData(token);
              if (userDataResponse.statusCode == 200) {
                userDataFetched = true;
              } else {
                await Future.delayed(Duration(milliseconds: 500 * attempt));
              }
            } catch (e) {
              lastError = e is Exception ? e : Exception(e.toString());
              await Future.delayed(Duration(milliseconds: 500 * attempt));
            }
          }
          
          if (userDataFetched) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomepageWidget()),
            );
          } else {
            throw lastError ?? Exception('Could not validate user data after multiple attempts');
          }
        } catch (e) {
          setState(() {
            _errorMessage = 'Account created but login required: ${e.toString()}';
          });
          // Force user to login manually if automatic login fails
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Registration failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
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

                        // Sign In Button
                        SubmitBox(
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
