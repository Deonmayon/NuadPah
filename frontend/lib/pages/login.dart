import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'welcome.dart';
import 'register.dart';
import '/pages/forgetpassword/forget.dart';
import '/components/emailtextfield.dart';
import '/components/passwordfield.dart';
import '/components/submitbox.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    'Welcome Back!',
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
                          controller: _usernameController,
                          hintText: 'Email',
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //   color: Color(0xFFE8E8E8),
                        //   borderRadius: BorderRadius.circular(15), // Less curve for rectangle-like shape
                        //   boxShadow: [
                        //     BoxShadow(
                        //     color: Colors.black.withOpacity(0.05),
                        //     blurRadius: 5,
                        //     offset: Offset(0, 3),
                        //     ),
                        //   ],
                        //   ),
                        //   child: TextField(
                        //   controller: _usernameController,
                        //   decoration: InputDecoration(
                        //     hintText: 'Email',
                        //     hintStyle: TextStyle(color: Colors.grey),
                        //     border: InputBorder.none,
                        //     contentPadding: EdgeInsets.symmetric(
                        //       horizontal: 25, vertical: 20),
                        //   ),
                        //   ),
                        // ),
                        SizedBox(height: 20),

                        // Password TextField
                        PasswordField(
                          controller: _passwordController,
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFFE8E8E8),
                        //     borderRadius: BorderRadius.circular(30),
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.05),
                        //         blurRadius: 5,
                        //         offset: Offset(0, 3),
                        //       ),
                        //     ],
                        //   ),
                        //   child: TextField(
                        //     controller: _passwordController,
                        //     obscureText: true,
                        //     decoration: InputDecoration(
                        //       hintText: 'Password',
                        //       hintStyle: TextStyle(color: Colors.grey),
                        //       border: InputBorder.none,
                        //       contentPadding: EdgeInsets.symmetric(
                        //           horizontal: 25, vertical: 20),
                        //       suffixIcon: Padding(
                        //         padding: EdgeInsets.only(right: 15),
                        //         child: Icon(Icons.visibility_off,
                        //             color: Colors.grey),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        if (_errorMessage.isNotEmpty)
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
                              'forget your password ?',
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
                          onPress: _login,
                          buttonText: 'ลงชื่อเข้าใช้',
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   height: 55,
                        //   child: ElevatedButton(
                        //     onPressed: _login,
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Color(0xFFC0A172),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(30),
                        //       ),
                        //       elevation: 5,
                        //     ),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         Text(
                        //           'Sign In',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //         SizedBox(width: 10),
                        //         Icon(Icons.arrow_forward, color: Colors.white),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        SizedBox(height: 30),

                        // Or Sign In With Text
                        Center(
                          child: Text(
                            'หรือลงชื่อเข้าใช้ด้วย',
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
                                    ..onTap = _register,
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
