import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '/pages/welcome.dart';
import '/pages/forgetpassword/otp.dart';
import '/components/emailtextfield.dart';
import '/components/submitbox.dart';

class ForgetPage extends StatefulWidget {
  const ForgetPage({super.key});

  @override
  _ForgetPageState createState() => _ForgetPageState();
}

class _ForgetPageState extends State<ForgetPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'admin' && password == '1234') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  void _otp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPPage(
        onCompleted: (_) {},  // Pass empty callback since we're using _reset() for navigation
        ),
  ),
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
                    'Forget Password ?',
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
                          'Enter Your Email',
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xFFBFAB93),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'We’ll send you a reset link to your email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF676767),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

                        // Email TextField
                        EmailTextField(
                          controller: _usernameController,
                          hintText: 'Email',
                        ),
                        SizedBox(height: 40),

                        // Sign In Button
                        SizedBox(height: 20),
                        SubmitBox(
                          buttonText: 'Submit',
                          onPress: _otp,
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
