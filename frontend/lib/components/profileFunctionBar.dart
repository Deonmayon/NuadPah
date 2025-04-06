import 'package:flutter/material.dart';

class ProfileFunctionBar extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool showArrow;
  final String? path;
  final Function()? onTap;

  const ProfileFunctionBar({
    super.key,
    required this.icon,
    required this.title,
    this.showArrow = true,
    this.path,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? (path != null ? () => Navigator.pushNamed(context, path!) : null),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 50,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: const Border(
            bottom: BorderSide(
              color: Color(0x26000000),
              width: 1.95,
            ),
            right: BorderSide(
              color: Color(0x26000000),
              width: 1.95,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: const Color.fromRGBO(103, 103, 103, 1),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
            if (showArrow)
              const Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Color.fromRGBO(103, 103, 103, 1),
              ),
          ],
        ),
      ),
    );
  }
}
