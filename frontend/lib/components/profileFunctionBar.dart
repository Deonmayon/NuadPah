import 'package:flutter/material.dart';

class ProfileFunctionBar extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool showArrow; // parameter for trailing arrow

  const ProfileFunctionBar({
    super.key,
    required this.icon,
    required this.title,
    this.showArrow = true, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.9, 
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.grey,
            width: 0.5,
          )
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (showArrow)
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}
