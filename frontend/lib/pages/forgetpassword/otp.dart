import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/pages/forgetpassword/reset.dart';
import '/components/submitbox.dart';

class OTPPage extends StatefulWidget {
  final int length;
  final Function(String)? onCompleted;

  const OTPPage({Key? key, this.length = 4, this.onCompleted}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;
  late List<String> _pin;
  String _errorMessage = '';

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

  void _reset() {
    if (_pin.contains('')) {
      setState(() {
        _errorMessage = "Please complete the OTP.";
      });
    } else {
      setState(() {
        _errorMessage = '';
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPage()),
      );
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
                          'Name@gmail.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF676767),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),

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
                            onChanged: (value) => _onPinChanged(index, value),
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
                      const SizedBox(height: 40),

                      // Next Button
                      SubmitBox(
                          buttonText: 'Next',
                          onPress: _reset,
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