import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/massage.dart';

class MassageCardSet extends StatefulWidget {
  final int ms_id;
  final String title;
  final String description;
  final List<String> types;
  final int duration;
  final String imageUrl1;
  final String imageUrl2;
  final String imageUrl3;
  final Function(bool) onFavoriteChanged;

  const MassageCardSet({
    Key? key,
    required this.ms_id,
    required this.title,
    required this.description,
    required this.types,
    required this.duration,
    required this.imageUrl1,
    required this.imageUrl2,
    required this.imageUrl3,
    required this.onFavoriteChanged,
  }) : super(key: key);

  @override
  State<MassageCardSet> createState() => _MassageCardSetState();
}

class _MassageCardSetState extends State<MassageCardSet> {
  bool isFavorite = false;
  List<dynamic> favmassages = [];

  Map<String, dynamic> userData = {
    'email': '',
    'first_name': '',
    'last_name': '',
    'image_name': '',
    'role': '',
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await getUserEmail();
    await fetchMassages();
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("Token is null, user not logged in.");
      return;
    }

    try {
      final response = await apiService.getUserData(token);

      setState(() {
        userData = response.data;
      });
    } catch (e) {
      setState(() {
        print(
            "Error fetching massages: ${e.toString()}"); // Only prints error message
      });
    }
  }

  Future<void> fetchMassages() async {
    final apiService = MassageApiService();

    try {
      final response = await apiService.getFavSet(userData['email']);
      setState(() {
        favmassages = (response.data as List)
            .map((item) => item['ms_id'] as int)
            .toList();
        isFavorite = favmassages.contains(widget.ms_id);
      });
    } catch (e) {
      print("Error fetching massages: ${e.toString()}");
    }
  }

  Future<void> toggleFavorite() async {
    final apiService = MassageApiService();

    try {
      if (!isFavorite) {
        await apiService.favSet(userData['email'], widget.ms_id);
      } else {
        await apiService.unfavSet(userData['email'], widget.ms_id);
      }
      setState(() {
        isFavorite = !isFavorite;
      });
      widget.onFavoriteChanged(isFavorite);
    } catch (e) {
      print("Error toggling favorite: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      width: double.infinity,
      height: 180,
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
            child: Container(
              width: 130,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                        ),
                        child: Image.network(
                          widget.imageUrl1,
                          width: 65,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          widget.imageUrl2,
                          width: 65,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      widget.imageUrl3,
                      width: 130,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
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
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB1B1B1),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBDBDB),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "${widget.duration} minutes",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBDBDB),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'Type: ${widget.types.join(", ")}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
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
    );
  }
}
