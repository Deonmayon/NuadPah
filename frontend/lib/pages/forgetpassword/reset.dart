import 'package:flutter/material.dart';
import '/pages/signin.dart';
import '/components/submitbox.dart';
import '/components/passwordfield.dart';
import '../../api/auth.dart';

class ResetPage extends StatefulWidget {
  final String email;
  const ResetPage({super.key, required this.email});

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _errorMessage = '';

  bool _isNewPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  void initState() {
    super.initState();
  }

  Future<void> _newPassword() async {
    final apiService = AuthApiService();

    try {
      // Check password and confirm password match
      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = 'รหัสผ่านไม่ตรงกัน';
        });
      } else {
        final response = await apiService.resetPassword(
          widget.email,
          _newPasswordController.text,
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        } else {
          setState(() {
            _errorMessage = 'Reset failed';
          });
        }

        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _isNewPasswordObscured = !_isNewPasswordObscured;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    });
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
                    'รีเซ็ตรหัสผ่าน',
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
                          controller: _newPasswordController,
                          hintText: 'New Password',
                          isObscured: _isNewPasswordObscured,
                          onToggle: _toggleNewPasswordVisibility,
                        ),
                        SizedBox(height: 20),

                        // Confirm Password TextField
                        PasswordField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          isObscured: _isConfirmPasswordObscured,
                          onToggle: _toggleConfirmPasswordVisibility,
                        ),
                        SizedBox(height: 40),

                        // Error Message
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
                          onPress: _newPassword,
                          buttonText: 'รีเซ็ตรหัสผ่าน',
                          showArrow: false,
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
