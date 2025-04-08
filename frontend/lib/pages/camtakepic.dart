import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'results.dart'; // import หน้า results
import 'package:http/http.dart' as http;
import 'dart:convert';

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([]);
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CamtakepicPage(cameras: cameras),
      );
}

class CamtakepicPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CamtakepicPage({Key? key, required this.cameras}) : super(key: key);
  @override
  _CamtakepicPage createState() => _CamtakepicPage();
}

class _CamtakepicPage extends State<CamtakepicPage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('assess was denied');
            break;
          default:
            print('Error: ${e.code}\nError Message: ${e.description}');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            children: [
              Expanded(
                child: Stack(children: [
                  Positioned.fill(child: CameraPreview(_controller)),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40, left: 20),
                        child: CircleAvatar(
                          backgroundColor: Color(0xB3C0A172),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        width: 150,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Color(0xB3C0A172),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text("ถ่ายจุดนวด",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (!_controller.value.isInitialized ||
                                _controller.value.isTakingPicture) return;

                            final image = await _controller.takePicture();

                            // ✅ แสดง Popup Loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => Center(
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFC0A172)),
                                      ),
                                      SizedBox(height: 20),
                                      Text("กำลังประมวลผล...",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFFC0A172),
                                            decoration: TextDecoration.none,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            var uri = Uri.parse(
                                'http://nuadpah.phraya.net/predict-file');
                            var request = http.MultipartRequest('POST', uri);
                            request.files.add(await http.MultipartFile.fromPath(
                                'file', image.path));

                            var response = await request.send();

                            if (response.statusCode == 200) {
                              var responseBody =
                                  await response.stream.bytesToString();
                              var jsonData = json.decode(responseBody);

                              Navigator.pop(
                                  context); // ✅ ปิด popup loading ก่อนทำอย่างอื่น

                              if (jsonData['success'] == true) {
                                String imageUrl = jsonData['public_url'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResultsPage(imageUrl: imageUrl),
                                  ),
                                );
                              } else {
                                // ❌ กรณีไม่พบจุดนวด
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (_) => Center(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.close,
                                              color: Colors.red, size: 40),
                                          SizedBox(height: 20),
                                          Text(
                                            "ไม่พบจุดนวด",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("เกิดข้อผิดพลาดจาก API")),
                              );
                            }
                          } catch (e) {
                            print('Error capturing photo: $e');
                            Navigator.pop(context); // ปิด loading ถ้า error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("เกิดข้อผิดพลาดในการถ่ายภาพ")),
                            );
                          }
                        },
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFC0A172),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ),
      );
}
