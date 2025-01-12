import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SingleDetailWidget extends StatefulWidget {
  const SingleDetailWidget({super.key});

  @override
  State<SingleDetailWidget> createState() => _SingleDetailWidgetState();
}

class _SingleDetailWidgetState extends State<SingleDetailWidget> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
              Container(
                width: double.infinity,
                height: 225,
                child: Stack(
                  children: [
                    Image.network(
                      'https://picsum.photos/seed/459/600',
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
                          color: Color.fromRGBO(192, 161, 114, 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircleAvatar(
                              radius: 12.5,
                              backgroundImage: NetworkImage(
                                'https://picsum.photos/seed/32/600',
                              ),
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
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name Massage',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromRGBO(103, 103, 103, 1),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // จัดให้อยู่กลางในแนวนอน
                      children: [
                        Container(
                          width: 372,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(192, 161, 114, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              debugPrint('Learn with AI pressed');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
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

              // Review Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rate and Reviews',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.black,
                          letterSpacing: 0.0,
                        )),
                    const SizedBox(height: 10),
                    // Review Card
                    ReviewCard(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
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
          Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundImage:
                    NetworkImage('https://picsum.photos/seed/624/600'),
              ),
              const SizedBox(width: 8),
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
                      ? Color.fromRGBO(192, 161, 114, 1)
                      : Colors.grey,
                  size: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
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
