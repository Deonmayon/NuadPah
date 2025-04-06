import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/pages/homepage2.dart';
import 'signup.dart';
import '/pages/forgetpassword/forget.dart';
import '/components/emailtextfield.dart';
import '/components/passwordfield.dart';
import '/components/submitbox.dart';
import '../api/auth.dart'; // Import the ApiService class
import 'package:shared_preferences/shared_preferences.dart'; // like localStorage but in flutter
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  Future<void> _signin() async {
    final apiService = AuthApiService();

    try {
      final response = await apiService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (response.statusCode == 201) {
        // pull token from response and set token (like localStorage)
        final token = response.data;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomepageWidget()),
        );
      } else {
        setState(() {
          _errorMessage = 'Sign Up failed';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _gotoSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  void _forget() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgetPage()),
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
                    'ยินดีต้อนรับกลับ!',
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
                          'ลงชื่อเข้าใช้',
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xFFBFAB93),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

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

                        if (_errorMessage.isNotEmpty)
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),

                        // Forget Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _forget,
                            child: Text(
                              'ลืมรหัสผ่าน?',
                              style: TextStyle(
                                color: Color(0xFFBFAB93),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Sign In Button
                        SubmitBox(
                          onPress: _signin,
                          buttonText: 'ลงชื่อเข้าใช้',
                          showArrow: true,
                        ),
                        SizedBox(height: 30),

                        // Create Account Link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "ยังไม่มีบัญชี? ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'ลงทะเบียน',
                                  style: TextStyle(
                                    color: Color(0xFFBFAB93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _gotoSignUp,
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
