import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/pages/forgetpassword/reset.dart';
import '/components/submitbox.dart';
import '../../api/auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // like localStorage but in flutter

class OTPPage extends StatefulWidget {
  final int length;
  final Function(String)? onCompleted;
  final String email;

  const OTPPage(
      {Key? key, this.length = 4, this.onCompleted, required this.email})
      : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late List<String> _pin;
  String _errorMessage = '';
  bool _showResendButton = true;
  int _countdownSeconds = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _pin = List.filled(widget.length, '');
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _onPinChanged(int index, String value) {
    setState(() {
      if (value.isEmpty) {
        _pin[index] = '';
        if (index > 0) {
          _focusNodes[index - 1].requestFocus();
        }
      } else if (value.length == 1) {
        _pin[index] = value;
        if (index < widget.length - 1) {
          _focusNodes[index + 1].requestFocus();
        }
      }

      if (!_pin.contains('') && widget.onCompleted != null) {
        widget.onCompleted!(_pin.join());
      }
    });
  }

  void _startCountdown() {
    _countdownSeconds = 59;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          _showResendButton = true;
          _countdownTimer?.cancel();
        }
      });
    });
  }

  Future<void> _verifyotp() async {
    final apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');

    try {
      final response = await apiService.verifyOTP(
        widget.email,
        _pin.join(),
      );

      if (_pin.contains('')) {
        setState(() {
          _errorMessage = "Please complete the OTP.";
        });
      } else {
        setState(() {
          _errorMessage = '';
          if (response.statusCode == 200) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResetPage(email: widget.email)),
            );
          } else {
            setState(() {
              _errorMessage = 'Invalid OTP from frontend';
            });
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }


  Future<void> _resendotp() async {
    final apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');

    try {
      final response = await apiService.sendOTP(
        widget.email,
      );
      
      if (response.statusCode == 201) {
        setState(() {
          _showResendButton = false;
          _startCountdown();
        });
      } else {
        setState(() {
          _errorMessage = 'Resend failed';
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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFC0A172),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/mail.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),

            // White Container with Curved Top
            Positioned(
              top: 240,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 160,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Enter Verification Code',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFFBFAB93),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'We have sent a verification code to',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF676767),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF676767),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),

                      // Pin Input Field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.length, (index) {
                          return Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _pin[index].isNotEmpty
                                  ? const Color(0xFFC0A172)
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _pin[index].isNotEmpty
                                    ? const Color(0xFFC0A172)
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  counterText: '',
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                                onChanged: (value) =>
                                    _onPinChanged(index, value),
                                onSubmitted: (value) {
                                  if (value.isEmpty && index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                },
                              ),
                            ),
                          );
                        }),
                      ),

                      // Error Message
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Resend Button or Countdown Text
                      if (_showResendButton)
                        TextButton(
                          onPressed: _resendotp,
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(
                              color: Color(0xFFC0A172),
                              fontSize: 16,
                            ),
                          ),
                        )
                      else
                        Text(
                          'Your otp will expire in $_countdownSeconds seconds',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      SizedBox(height: 20),

                      // Next Button
                      SubmitBox(
                        buttonText: 'Next',
                        onPress: _verifyotp,
                        showArrow: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
