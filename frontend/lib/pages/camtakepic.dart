import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'results.dart'; // import หน้า results

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
                        padding: const EdgeInsets.only(top: 20, left: 20),
                        child: CircleAvatar(
                          backgroundColor: Color(0xB3C0A172),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            if (!_controller.value.isInitialized || _controller.value.isTakingPicture) return;

                            final image = await _controller.takePicture();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResultsPage(imagePath: image.path),
                              ),
                            );
                          } catch (e) {
                            print('Error capturing photo: $e');
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
