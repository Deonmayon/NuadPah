import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/pages/singleMassageDetail.dart';
import 'package:frontend/pages/setMassageDetail.dart';

class MassageCard extends StatefulWidget {
  final String image;
  final String name;
  final String detail;
  final String type;
  final int time;
  final int mtID;
  final String? rating;
  final bool isSet;
  final bool isFavorite; // Add this property
  final VoidCallback? onTap;
  final Function(bool) onFavoriteChanged;

  const MassageCard({
    Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.type,
    required this.time,
    required this.mtID,
    required this.rating,
    this.isSet = false,
    this.isFavorite = false, // Add default value
    this.onTap,
    required this.onFavoriteChanged,
  }) : super(key: key);

  String get ratingText => '${rating.toString()} / 5';

  @override
  State<MassageCard> createState() => _MassageCardState();
}

class _MassageCardState extends State<MassageCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    // Initialize from prop
    isFavorite = widget.isFavorite;
  }

  @override
  void didUpdateWidget(MassageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update state when prop changes
    if (oldWidget.isFavorite != widget.isFavorite) {
      setState(() {
        isFavorite = widget.isFavorite;
      });
    }
  }

  Future<void> toggleFavorite() async {
    // Update UI immediately for responsiveness
    setState(() {
      isFavorite = !isFavorite;
    });

    // Notify parent to handle the actual API call
    widget.onFavoriteChanged(isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isSet) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetMassageDetailPage(
                massageID: widget.mtID,
                rating: widget.ratingText,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleMassageDetailPage(
                massageID: widget.mtID,
                rating: widget.ratingText,
              ),
            ),
          );
        }
      },
      child: Container(
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
                  widget.image,
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
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.detail,
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
                            "บริเวณ : ${widget.type}",
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
                            "${widget.time} นาที",
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
                    icon: FaIcon(
                      FontAwesomeIcons.solidBookmark,
                      size: 15,
                      color: isFavorite
                          ? const Color.fromARGB(255, 255, 200, 0)
                          : Colors.white,
                    ),
                    onPressed: toggleFavorite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
