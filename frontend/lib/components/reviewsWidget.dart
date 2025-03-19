import 'package:flutter/material.dart';

class ReviewsWidget extends StatelessWidget {
  final List<dynamic> reviews;

  const ReviewsWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviews.map((review) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review['author_name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Rating: ${review['rating']}'),
              Text(review['text']),
              Text(
                'Reviewed on: ${DateTime.fromMillisecondsSinceEpoch(review['time'] * 1000).toString()}',
                style: TextStyle(color: Colors.grey),
              ),
              Divider(),
            ],
          ),
        );
      }).toList(),
    );
  }
}
