import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(MyApp(cameras: cameras));
}

enum PanelState { start, correct, place, rub, again, done }

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandscapePage(cameras: cameras),
      );
}

class LandscapePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const LandscapePage({Key? key, required this.cameras}) : super(key: key);
  @override
  _LandscapePageState createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  static const maxSeconds = 300, maxRounds = 20;
  int remainingSeconds = maxSeconds, currentRound = 0;
  Timer? timer;
  PanelState currentState = PanelState.rub;

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

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if ((currentState == PanelState.rub ||
              currentState == PanelState.again ||
              currentState == PanelState.done) &&
          remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      }
      if (remainingSeconds == 0 || currentRound == maxRounds) {
        timer.cancel();
        _showEndDialog(); // เรียก dialog ทันที
      }
    });
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("สนุกไหม?"),
          content: Text("แบ่งปันความคิดเห็นของคุณกับเรา"),
          actions: <Widget>[
            TextButton(
              child: Text('ไม่'),
              onPressed: () {
                Navigator.of(context).pop();
                _showRetryDialog();
              },
            ),
            TextButton(
              child: Text('ใช่'),
              onPressed: () {
                Navigator.of(context).pop();
                _showReviewDialog();
              },
            ),
          ],
        );
      },
    );
  }

  int _selectedStars = 0;

  void _showReviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("คะแนนและความคิดเห็น"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _selectedStars
                              ? Icons.star
                              : Icons.star_border,
                          color: Color(0xFFC0A172),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedStars =
                                index + 1; // อัปเดตจำนวนดาวที่เลือก
                          });
                        },
                      );
                    }),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "แบ่งปันความคิดเห็นของคุณ",
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('ยกเลิก'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showRetryDialog();
                  },
                ),
                TextButton(
                  child: Text('ยืนยัน'),
                  onPressed: () {
                    print("User rated: $_selectedStars stars"); // ลอง print ดู
                    Navigator.of(context).pop();
                    _showRetryDialog();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("พร้อมที่จะเริ่มใหม่หรือยัง?"),
          content: Text("แตะที่ปุ่ม 'เริ่มใหม่' เพื่อเริ่มใหม่"),
          actions: <Widget>[
            TextButton(
              child: Text('ไม่'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('เริ่มใหม่'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      remainingSeconds = maxSeconds;
      currentRound = 0;
      currentState = PanelState.start;
      timer?.cancel();
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if ((currentState == PanelState.rub ||
                currentState == PanelState.again ||
                currentState == PanelState.done) &&
            remainingSeconds > 0) {
          setState(() => remainingSeconds--);
        } else if (remainingSeconds == 0 || currentRound == maxRounds) {
          timer.cancel();
          _showEndDialog();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void incrementRound() {
    if (currentRound < maxRounds) setState(() => currentRound++);
  }

  Widget buildIndicator(double value, String label, String text) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 7,
              backgroundColor: Color(0xB3C0A172),
              valueColor: AlwaysStoppedAnimation(Color(0xFFC0A172)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 8, color: Color(0xFFC0A172))),
              Text(text,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC0A172))),
            ],
          ),
        ],
      );

  Widget buildPanelByState(PanelState state) {
    return Expanded(
      child: () {
        if (currentState == PanelState.again) {
          state = PanelState.rub;
        } else if (currentState == PanelState.done) {
          state = PanelState.rub;
        }

        switch (state) {
          case PanelState.correct:
            return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF5A7654),
                    width: 5,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(200),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Stack(
                    children: [
                      Positioned.fill(child: CameraPreview(_controller)),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CircleAvatar(
                              backgroundColor: Color(0xB3C0A172),
                              child: IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 73),
                          child: Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xB35A7654),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Correct !",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 42,
                          left: 90,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 42,
                        right: 90,
                        child: GestureDetector(
                          onTap: incrementRound,
                          child: buildIndicator(currentRound / maxRounds,
                              "Round", "$currentRound"),
                        ),
                      ),
                    ],
                  ),
                ));
          case PanelState.place:
            return DottedBorder(
                color: Color(0xFFC0A172),
                strokeWidth: 5,
                dashPattern: [10, 10],
                borderType: BorderType.RRect,
                radius: Radius.circular(200),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Stack(
                    children: [
                      Positioned.fill(child: CameraPreview(_controller)),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CircleAvatar(
                              backgroundColor: Color(0xB3C0A172),
                              child: IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 73),
                          child: Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xB3C0A172),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Place your fingers",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 42,
                          left: 90,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 42,
                        right: 90,
                        child: GestureDetector(
                          onTap: incrementRound,
                          child: buildIndicator(currentRound / maxRounds,
                              "Round", "$currentRound"),
                        ),
                      ),
                    ],
                  ),
                ));
          case PanelState.rub:
            return DottedBorder(
                color: Color(0xFFC0A172),
                strokeWidth: 5,
                dashPattern: [10, 10],
                borderType: BorderType.RRect,
                radius: Radius.circular(200),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Stack(
                    children: [
                      Positioned.fill(child: CameraPreview(_controller)),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CircleAvatar(
                              backgroundColor: Color(0xB3C0A172),
                              child: IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 73),
                          child: Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xB3C0A172),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Builder(
                                builder: (context) {
                                  if (currentState == PanelState.rub) {
                                    return Text("Rub down to the line",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500));
                                  } else if (currentState == PanelState.again) {
                                    return Text("Great ! Do it again",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500));
                                  } else if (currentState == PanelState.done) {
                                    return Text("Done !",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500));
                                  }
                                  return SizedBox(); // ค่า default (กรณีไม่มี state ที่ตรง)
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 42,
                          left: 90,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 42,
                        right: 90,
                        child: GestureDetector(
                          onTap: incrementRound,
                          child: buildIndicator(currentRound / maxRounds,
                              "Round", "$currentRound"),
                        ),
                      ),
                    ],
                  ),
                ));

          case PanelState.start:
          default:
            return DottedBorder(
                color: Color(0xFFC0A172),
                strokeWidth: 5,
                dashPattern: [10, 10],
                borderType: BorderType.RRect,
                radius: Radius.circular(200),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Stack(
                    children: [
                      Positioned.fill(child: CameraPreview(_controller)),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: CircleAvatar(
                              backgroundColor: Color(0xB3C0A172),
                              child: IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 73),
                          child: Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xB3C0A172),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Move Your Camera",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 42,
                          left: 90,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 42,
                        right: 90,
                        child: GestureDetector(
                          onTap: incrementRound,
                          child: buildIndicator(currentRound / maxRounds,
                              "Round", "$currentRound"),
                        ),
                      ),
                    ],
                  ),
                ));
        }
      }(),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 83, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    buildPanelByState(currentState),
                    buildPanelByState(currentState)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
