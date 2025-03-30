import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '/pages/welcome.dart';
import '/pages/register.dart';
import '/components/submitbox.dart';
import '/components/passwordfield.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
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

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
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
                    'Reset Your Password',
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
                          'ใส่รหัสผ่านใหม่',
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xFFBFAB93),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

                        // Password TextField
                        PasswordField(
                          controller: _passwordController,
                        ),
                        SizedBox(height: 20),

                        // Confirm Password TextField
                        PasswordField(
                          controller: _passwordController,
                        ),
                        SizedBox(height: 40),

                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),

                        // Reset Password Button
                        SubmitBox(
                        onPress: _login,
                        buttonText: 'รีเซ็ตรหัสผ่าน',
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   height: 55,
                        //   child: ElevatedButton(
                        //     onPressed: _login,
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Color(0xFFC0A172),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //       elevation: 5,
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //      Text(
                        //           'Reset Password',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //       ],
                        //     ),
                        //   ),
                        // ),   

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
