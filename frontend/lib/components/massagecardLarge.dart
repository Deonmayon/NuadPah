import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MassageCardLarge extends StatelessWidget {
  final String name;
  final String score;
  final String type;
  final String image;
  final bool isSet;

  const MassageCardLarge({
    Key? key,
    required this.name,
    required this.score,
    required this.type,
    required this.image,
    required this.isSet,
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
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.network(
                  image.isNotEmpty
                      ? image
                      : 'https://via.placeholder.com/290x140',
                  width: 290,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image_not_supported,
                        size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                name.isNotEmpty ? name : 'Unknown Name',
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
                  Icon(FontAwesomeIcons.solidStar,
                      size: 15, color: Color(0xFFB1B1B1)),
                  SizedBox(width: 5),
                  Text(
                    score.isNotEmpty ? score : 'N/A',
                    style: TextStyle(fontSize: 12, color: Color(0xFF676767)),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Type: ${type.isNotEmpty ? type : "Unknown"}',
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
