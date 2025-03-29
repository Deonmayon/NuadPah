import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetMassageDetailPage extends StatefulWidget {
  const SetMassageDetailPage({super.key});

  @override
  State<SetMassageDetailPage> createState() => _SetMassageDetailPageState();
}

class _SetMassageDetailPageState extends State<SetMassageDetailPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header with image and buttons
              SizedBox(
                width: double.infinity,
                height: 225,
                child: PageView(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/Massage_Image01.png',
                          width: double.infinity,
                          height: 210,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.solidBookmark,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              debugPrint('Bookmark pressed');
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(192, 161, 114, 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12.5,
                                  backgroundImage: AssetImage(
                                      'assets/images/Massage_Image01.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Type: Shoulder',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 16),
                                FaIcon(
                                  FontAwesomeIcons.solidClock,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '\u2248 5 mins',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 16),
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '4.5/5.0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // หน้าที่สอง
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/Massage_Image03.png',
                          width: double.infinity,
                          height: 210,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.solidBookmark,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              debugPrint('Bookmark pressed');
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(192, 161, 114, 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12.5,
                                  backgroundImage: AssetImage(
                                      'assets/images/Massage_Image01.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Type: Shoulder',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 16),
                                FaIcon(
                                  FontAwesomeIcons.solidClock,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '\u2248 5 mins',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 16),
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '4.5/5.0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/Massage_Image11.png',
                          width: double.infinity,
                          height: 210,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.solidBookmark,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              debugPrint('Bookmark pressed');
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(192, 161, 114, 1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 12.5,
                                  backgroundImage: AssetImage(
                                      'assets/images/Massage_Image01.png'),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Type: Shoulder',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 16),
                                FaIcon(
                                  FontAwesomeIcons.solidClock,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '\u2248 5 mins',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 16),
                                FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '4.5/5.0',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name Massage',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // จัดให้อยู่กลางในแนวนอน
                      children: [
                        SizedBox(
                          width: 372,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(192, 161, 114, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              debugPrint('Learn with AI pressed');
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Learn with AI',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                FaIcon(
                                  FontAwesomeIcons.vrCardboard,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ⬇️ ส่วนนี้เลื่อนได้
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ExpandableCard(
                          title: "Name Massage",
                          imagePath: "assets/images/Massage_Image01.png",
                          type: "Back",
                          duration: "≈ 5 minutes",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ExpandableCard(
                          title: "Name Massage",
                          imagePath: "assets/images/Massage_Image01.png",
                          type: "Back",
                          duration: "≈ 5 minutes",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ExpandableCard(
                          title: "Name Massage",
                          imagePath: "assets/images/Massage_Image01.png",
                          type: "Back",
                          duration: "≈ 5 minutes",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rate and Reviews',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.black,
                                letterSpacing: 0.0,
                              ),
                            ),
                            SizedBox(height: 10),
                            ReviewCard(),
                            SizedBox(height: 10),
                            ReviewCard(),
                            SizedBox(height: 10),
                            ReviewCard(),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ), // Review Sectio
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final String type;
  final String duration;

  ExpandableCard({
    required this.title,
    required this.imagePath,
    required this.type,
    required this.duration,
  });

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.imagePath,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBDBDB),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "Type : ${widget.type}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBDBDB),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  widget.duration,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Color.fromRGBO(192, 161, 114, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 8),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud quip.",
                  style: TextStyle(color: Colors.black),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: AssetImage('assets/images/profilePicture.jpg'),
              ),
              SizedBox(width: 8),
              Text(
                'Cameron Williamson',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromRGBO(103, 103, 103, 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              5,
              (index) => Padding(
                padding:
                    const EdgeInsets.only(right: 5.0), // ระยะห่างระหว่างไอคอน
                child: Icon(
                  index < 4
                      ? FontAwesomeIcons.solidStar
                      : FontAwesomeIcons.star,
                  color: index < 4
                      ? const Color.fromRGBO(192, 161, 114, 1)
                      : Colors.grey,
                  size: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Lorem ipsum dolor sit amet,  occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color.fromRGBO(103, 103, 103, 1),
            ),
          ),
        ],
      ),
    );
  }
}
