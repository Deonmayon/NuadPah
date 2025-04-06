import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../user_provider.dart';
import '../api/massage.dart';

class MassageCard extends StatefulWidget {
  final String image;
  final String name;
  final String detail;
  final String type;
  final int time;
  final int mt_id;
  final Function(bool) onFavoriteChanged;

  const MassageCard({
    Key? key,
    required this.image,
    required this.name,
    required this.detail,
    required this.type,
    required this.time,
    required this.mt_id,
    required this.onFavoriteChanged,
  }) : super(key: key);

  @override
  State<MassageCard> createState() => _MassageCardState();
}

class _MassageCardState extends State<MassageCard> {
  bool isFavorite = false;
  List<dynamic> favmassages = [];

  @override
  void initState() {
    super.initState();
    fetchMassages();
  }

  Future<void> fetchMassages() async {
    final apiService = MassageApiService(baseUrl: 'http://10.0.2.2:3001');
    final email =
        Provider.of<UserProvider>(context, listen: false).email; // Get email

    try {
      final response = await apiService.getFavSingle(email);

      setState(() {
        favmassages = (response.data as List)
            .map((item) => item['mt_id'] as int)
            .toList();
        isFavorite = favmassages.contains(widget.mt_id);
      });
    } catch (e) {
      print("Error fetching massages: ${e.toString()}");
    }
  }

  Future<void> toggleFavorite() async {
    final apiService = MassageApiService(baseUrl: 'http://10.0.2.2:3001');
    final email = Provider.of<UserProvider>(context, listen: false).email;

    try {
      if (!isFavorite) {
        await apiService.favSingle(email, widget.mt_id);
      } else {
        await apiService.unfavSingle(email, widget.mt_id);
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
                          "Type : ${widget.type}",
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
                          "${widget.time} minutes",
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
                    color: isFavorite ? const Color.fromARGB(255, 255, 200, 0) : Colors.white,
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
            mt_id: 1,
            onFavoriteChanged: (isFavorite) {
              print('Favorite status changed: $isFavorite');
            },
          ),
        ),
      ),
    );
  }
}