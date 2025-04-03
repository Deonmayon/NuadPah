import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MassageCard extends StatelessWidget {
  final String image;
  final String name;
  final String detail;
  final String type;
  final int time;

  const MassageCard({
    Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.type,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Color(0x40000000),
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    detail,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDBDBDB),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Type : $type",
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
                          "≈ $time minutes",
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFDBDBDB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  icon: const FaIcon(
                    FontAwesomeIcons.solidBookmark,
                    size: 15,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Massage Card Example')),
        body: Center(
          child: MassageCard(
            image: 'https://via.placeholder.com/100',
            name: 'Relaxing Massage',
            detail: 'A relaxing massage to relieve stress and tension.',
            type: 'Swedish',
            time: 100,
          ),
        ),
      ),
    );
  }
}