import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:frontend/pages/homepage.dart';
import 'welcome.dart';
import 'login.dart';
import '/components/emailtextfield.dart';
import '/components/passwordfield.dart';
import '/components/submitbox.dart';
import '../api/api.dart'; // Import the ApiService class

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _signup() async {
    print('Signup method called');
    final apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');

    try {
      final response = await apiService.signUp(
        _emailController.text,
        _passwordController.text,
        _firstnameController.text,
        _lastnameController.text,
      );
      // print('Signup method called 2');
      // print('Response status code: ${response.statusCode}');
      // print('Response data: ${response.data}');
      // print('Response headers: ${response.headers}');
      // print('Response status message: ${response.statusMessage}');

      // if (response.statusCode == 201) {
      //   if (mounted) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Homepage()),
      //     );
      //   }
      // } else {
      //   setState(() {
      //     _errorMessage = 'Registration failed';
      //   });
      // }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _gotologin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
                    'Get Started!',
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
                          'Sign Up',
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
                                hintText: 'First Name',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: EmailTextField(
                                controller: _lastnameController,
                                hintText: 'Last Name',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Email TextField
                        EmailTextField(
                          controller: _emailController,
                          hintText: 'Email',
                        ),
                        SizedBox(height: 20),

                        // Password TextField
                        PasswordField(
                          controller: _passwordController,
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
                          buttonText: 'Sign Up',
                          onPress: _signup,
                        ),

                        SizedBox(height: 30),

                        // Or Sign In With Text
                        Center(
                          child: Text(
                            'Or Sign Up With',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Google Sign In Button
                        Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'G',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFFBFAB93),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        // Create Account Link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: Color(0xFFBFAB93),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _gotologin,
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
