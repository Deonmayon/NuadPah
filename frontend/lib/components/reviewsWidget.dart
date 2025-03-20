import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewsCard extends StatelessWidget {
  final List<dynamic> reviews;

  const ReviewsCard({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviews.map((review) {
        return Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 20),
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
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage('assets/images/reviewer.png'),
                  ),
                  SizedBox(width: 8),
                  Text(
                    review['author_name'] ?? 'John Doe',
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
                    padding: const EdgeInsets.only(
                        right: 5.0), // ระยะห่างระหว่างไอคอน
                    child: Icon(
                      index <= review['rating']
                          ? FontAwesomeIcons.solidStar
                          : FontAwesomeIcons.star,
                      color: index <= review['rating']
                          ? const Color.fromRGBO(192, 161, 114, 1)
                          : Colors.grey,
                      size: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                review['text'],
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color.fromRGBO(103, 103, 103, 1),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
