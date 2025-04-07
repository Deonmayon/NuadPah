import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReviewCard extends StatelessWidget {
  final int reviewID;
  final String imageName;
  final String firstname;
  final String lastname;
  final int rating;
  final String detail;
  final String datetime;

  const ReviewCard({
    super.key,
    required this.reviewID,
    required this.imageName,
    required this.firstname,
    required this.lastname,
    required this.rating,
    required this.detail,
    required this.datetime,
  });

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
              CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(
                  imageName.isNotEmpty
                      ? imageName
                      : 'https://dxaytybkoraatubbincp.supabase.co/storage/v1/object/public/nuadpahstorage//user_icon.png',
                ),
                onBackgroundImageError: (exception, stackTrace) {
                  debugPrint('Error loading image: $exception');
                },
                child: imageName.isEmpty
                    ? const Icon(Icons.person, size: 20, color: Colors.grey)
                    : null,
              ),
              SizedBox(width: 8),
              Text(
                '$firstname $lastname',
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
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  index < rating
                      ? FontAwesomeIcons.solidStar
                      : FontAwesomeIcons.star,
                  color: index < rating
                      ? const Color.fromRGBO(192, 161, 114, 1)
                      : Colors.grey,
                  size: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            detail,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color.fromRGBO(103, 103, 103, 1),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
