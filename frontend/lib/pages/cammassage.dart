import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

enum PanelState { start, correct, place, rub, again, done }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LandscapePage(),
      );
}

class LandscapePage extends StatefulWidget {
  @override
  _LandscapePageState createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  static const maxSeconds = 300, maxRounds = 20;
  int remainingSeconds = maxSeconds, currentRound = 0;
  Timer? timer;
  PanelState currentState = PanelState.done;

  @override
  void initState() {
    super.initState();
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
          title: Text("Enjoyed it?"),
          content: Text("Share your experience with us!"),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                _showRetryDialog();
              },
            ),
            TextButton(
              child: Text('Yes'),
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
              title: Text("Rate and Review"),
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
                      hintText: "Share your massage experience here...",
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showRetryDialog();
                  },
                ),
                TextButton(
                  child: Text('Submit'),
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
          title: Text("Ready to try again?"),
          content: Text("Tap restart"),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Restart'),
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
    super.dispose();
  }

  void incrementRound() {
    if (currentRound < maxRounds) setState(() => currentRound++);
  }

  Widget buildIndicator(double value, String label, String text) => Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
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
                  style: TextStyle(fontSize: 12, color: Color(0xFFC0A172))),
              Text(text,
                  style: TextStyle(
                      fontSize: 20,
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
                    Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
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
                          bottom: 20,
                          left: 20,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 20,
                        right: 20,
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
                dashPattern: [25, 25],
                borderType: BorderType.RRect,
                radius: Radius.circular(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
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
                          bottom: 20,
                          left: 20,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 20,
                        right: 20,
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
                dashPattern: [25, 25],
                borderType: BorderType.RRect,
                radius: Radius.circular(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
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
                              child: Builder(
                                builder: (context) {
                                  if (currentState  == PanelState.rub) {
                                    return Text("Rub down to the line",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500));
                                  } else if (currentState  == PanelState.again) {
                                    return Text("Great ! Do it again",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500));
                                  } else if (currentState  == PanelState.done) {
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
                          bottom: 20,
                          left: 20,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 20,
                        right: 20,
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
                dashPattern: [25, 25],
                borderType: BorderType.RRect,
                radius: Radius.circular(30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
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
                          bottom: 20,
                          left: 20,
                          child: buildIndicator(
                              remainingSeconds / maxSeconds,
                              "Time",
                              "${remainingSeconds ~/ 60}:${(remainingSeconds % 60).toString().padLeft(2, '0')}")),
                      Positioned(
                        bottom: 20,
                        right: 20,
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
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    buildPanelByState(currentState),
                    SizedBox(width: 10),
                    buildPanelByState(currentState)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
