import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MassageCardLarge extends StatelessWidget {
  final String image;
  final String avatar;
  final String name;
  final String type;
  final String duration;
  final String rating;

  const MassageCardLarge({
    Key? key,
    required this.image,
    required this.avatar,
    required this.name,
    required this.type,
    required this.duration,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: 290,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: const Color(0x40000000),
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 135,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.network(
                      image,
                      width: 290,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0x99DBDBDB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        icon: const FaIcon(
                          FontAwesomeIcons.solidBookmark,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 15,
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 12.5,
                            backgroundImage: NetworkImage(avatar),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Type: $type',
                            style: TextStyle(
                              color: Colors.black,
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
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.solidClock,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    '≈ $duration',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                  SizedBox(width: 10),
                  Icon(FontAwesomeIcons.solidStar,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    rating,
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}