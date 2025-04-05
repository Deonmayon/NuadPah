import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([

  ]);
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

    // เชื่อมต่อกับเซิร์ฟเวอร์ Python
    IO.Socket socket = IO.io(
      'http://10.0.2.2:5000', // เปลี่ยนเป็น IP จริงของเซิร์ฟเวอร์
      IO.OptionBuilder()
          .setTransports(['websocket']) // ใช้ WebSocket
          .disableAutoConnect() // ป้องกันการเชื่อมต่ออัตโนมัติ
          .build(),
    );

    socket.connect(); // เชื่อมต่อ

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit('message', 'Hello from Flutter!'); // ส่งข้อความไปเซิร์ฟเวอร์
    });

    socket.on('message', (data) {
      print('Server: $data'); // ควรแสดงข้อความจากเซิร์ฟเวอร์ใน Flutter terminal
    });

    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((_) => print('Disconnected from server'));

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
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFC0A172), // สีตรงกลางปุ่ม
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // ขอบสีขาว
                              width: 4,
                            ),
                          ),
                        ),
                      )),
                ]),
              )
            ],
          ),
        ),
      );
}
