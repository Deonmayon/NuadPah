import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/massage.dart';
import '../utils/favorite_manager.dart'; // New import

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
    // Check favorite status from global cache immediately
    _checkFavoriteStatus();
    // Then load complete data
    loadData();
  }

  void _checkFavoriteStatus() {
    // Get favorite status from FavoriteManager - immediate synchronous operation
    final favoriteStatus = FavoriteManager.instance.isSingleFavorite(widget.mt_id);
    if (favoriteStatus != null && favoriteStatus != isFavorite) {
      setState(() {
        isFavorite = favoriteStatus;
      });
    }
  }

  Future<void> _checkCachedFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedFavorites = prefs.getStringList('cachedFavorites') ?? [];
    
    if (cachedFavorites.isNotEmpty) {
      setState(() {
        favmassages = cachedFavorites.map((id) => int.parse(id)).toList();
        isFavorite = favmassages.contains(widget.mt_id);
      });
    }
  }

  Future<void> loadData() async {
    // Start both operations in parallel
    final emailFuture = getUserEmail();
    
    // Check cached favorites while waiting for email
    await _checkCachedFavorites();
    
    // Wait for email to be retrieved
    await emailFuture;
    
    // Only proceed if we have a valid email
    if (userData['email'].isNotEmpty) {
      // Fetch favorites data in background
      fetchMassages();
    }
  }

  Future<void> getUserEmail() async {
    final apiService = AuthApiService();

    // Try to load from local storage first for immediate response
    final prefs = await SharedPreferences.getInstance();
    final cachedEmail = prefs.getString('userEmail');
    final token = prefs.getString('token');

    if (cachedEmail != null && cachedEmail.isNotEmpty) {
      setState(() {
        userData['email'] = cachedEmail;
      });
    }

    if (token == null) {
      print("Token is null, user not logged in.");
      return;
    }

    try {
      final response = await apiService.getUserData(token);
      if (mounted) {
        setState(() {
          userData = response.data;
        });
        // Cache email for faster future loads
        prefs.setString('userEmail', userData['email']);
      }
    } catch (e) {
      print("Error fetching user data: ${e.toString()}");
    }
  }

  Future<void> fetchMassages() async {
    if (userData['email'].isEmpty) return;
    
    final apiService = MassageApiService();

    try {
      final response = await apiService.getFavSingle(userData['email']);
      
      if (mounted) {
        final List<int> newFavMassages = (response.data as List)
            .map((item) => Map<String, dynamic>.from(item)['mt_id'] as int)
            .toList();

        // Update global favorite manager
        FavoriteManager.instance.setSingleFavorites(newFavMassages);

        // Cache favorites for faster future loads
        final prefs = await SharedPreferences.getInstance();
        prefs.setStringList('cachedFavorites', 
            newFavMassages.map((id) => id.toString()).toList());
            
        setState(() {
          favmassages = newFavMassages;
          isFavorite = favmassages.contains(widget.mt_id);
        });
      }
    } catch (e) {
      print("Error fetching massages: ${e.toString()}");
    }
  }

  Future<void> toggleFavorite() async {
    final apiService = MassageApiService();

    try {
      // Update UI immediately for responsiveness
      setState(() {
        isFavorite = !isFavorite;
      });
      widget.onFavoriteChanged(isFavorite);
      
      // Update the global favorite state
      FavoriteManager.instance.updateSingleFavorite(widget.mt_id, isFavorite);
      
      // Then perform the API call
      if (isFavorite) {
        await apiService.favSingle(userData['email'], widget.mt_id);
      } else {
        await apiService.unfavSingle(userData['email'], widget.mt_id);
      }

      // Update cached favorites
      if (isFavorite && !favmassages.contains(widget.mt_id)) {
        favmassages.add(widget.mt_id);
      } else if (!isFavorite) {
        favmassages.remove(widget.mt_id);
      }
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('cachedFavorites', 
          favmassages.map((id) => id.toString()).toList());
          
    } catch (e) {
      // Revert UI change if API call fails
      setState(() {
        isFavorite = !isFavorite;
      });
      // Also revert global state
      FavoriteManager.instance.updateSingleFavorite(widget.mt_id, !isFavorite);
      widget.onFavoriteChanged(isFavorite);
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
