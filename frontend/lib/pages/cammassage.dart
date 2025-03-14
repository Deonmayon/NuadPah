import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return LandscapePage(camera: snapshot.data!.first);
            } else {
              return Center(child: Text("No Camera Available"));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class LandscapePage extends StatefulWidget {

  final CameraDescription camera;
  LandscapePage({required this.camera});

  @override
  _LandscapePageState createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  static const int maxSeconds = 300; // 5 minutes
  int remainingSeconds = maxSeconds;
  Timer? timer;
  static const int maxRounds = 20;
  int currentRound = 0;

  void incrementRound() {
    if (currentRound < maxRounds) {
      setState(() {
        currentRound++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progresstime = remainingSeconds / maxSeconds;
    double progressround = currentRound > 0 ? currentRound / maxRounds : 0.0;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: buildUIContainer(progresstime, "Time", "${(remainingSeconds ~/ 60).toString()}:${(remainingSeconds % 60).toString().padLeft(2, '0')}"),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: incrementRound,
                    child: buildUIContainer(progressround, "Round", "$currentRound"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUIContainer(double progress, String label, String value) {
    return DottedBorder(
      color: Color(0xFFC0A172),
      strokeWidth: 5,
      dashPattern: [25, 25],
      borderType: BorderType.RRect,
      radius: Radius.circular(30),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: CircleAvatar(
                backgroundColor: Color(0xB3C0A172),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 250,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xB3C0A172),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Move Your Camera",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 7,
                      backgroundColor: Color(0xB3C0A172),
                      valueColor: AlwaysStoppedAnimation(Color(0xFFC0A172)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: TextStyle(fontSize: 12, color: Color(0xFFC0A172)),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC0A172),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
