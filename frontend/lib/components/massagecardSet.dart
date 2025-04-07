import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/auth.dart';
import 'package:frontend/pages/setMassageDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/massage.dart';
import '../utils/favorite_manager.dart'; // Add this import

class MassageCardSet extends StatefulWidget {
  final int ms_id;
  final String title;
  final String description;
  final List<String> types;
  final int duration;
  final List<String> images;
  final Function(bool) onFavoriteChanged;

  const MassageCardSet({
    Key? key,
    required this.ms_id,
    required this.title,
    required this.description,
    required this.types,
    required this.duration,
    required this.images,
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
    // Check favorite status from global cache immediately
    _checkFavoriteStatus();
    // Then load complete data
    loadData();
  }

  void _checkFavoriteStatus() {
    // Get favorite status from FavoriteManager - immediate synchronous operation
    final favoriteStatus = FavoriteManager.instance.isSetFavorite(widget.ms_id);
    if (favoriteStatus != null && favoriteStatus != isFavorite) {
      setState(() {
        isFavorite = favoriteStatus;
      });
    }
  }

  // Check cached favorites for faster initial load
  Future<void> _checkCachedFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedFavorites = prefs.getStringList('cachedSetFavorites') ?? [];
    
    if (cachedFavorites.isNotEmpty) {
      setState(() {
        favmassages = cachedFavorites.map((id) => int.parse(id)).toList();
        isFavorite = favmassages.contains(widget.ms_id);
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
    if (!mounted) return;
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
      final response = await apiService.getFavSet(userData['email']);
      
      if (mounted) {
        final List<int> newFavMassages = (response.data as List)
            .map((item) => item['ms_id'] as int)
            .toList();

        // Update global favorite manager
        FavoriteManager.instance.setSetFavorites(newFavMassages);

        // Cache favorites for faster future loads
        final prefs = await SharedPreferences.getInstance();
        prefs.setStringList('cachedSetFavorites', 
            newFavMassages.map((id) => id.toString()).toList());
            
        setState(() {
          favmassages = newFavMassages;
          isFavorite = favmassages.contains(widget.ms_id);
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
      FavoriteManager.instance.updateSetFavorite(widget.ms_id, isFavorite);
      
      // Then perform the API call
      if (isFavorite) {
        await apiService.favSet(userData['email'], widget.ms_id);
      } else {
        await apiService.unfavSet(userData['email'], widget.ms_id);
      }

      // Update cached favorites
      if (isFavorite && !favmassages.contains(widget.ms_id)) {
        favmassages.add(widget.ms_id);
      } else if (!isFavorite) {
        favmassages.remove(widget.ms_id);
      }
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('cachedSetFavorites', 
          favmassages.map((id) => id.toString()).toList());
          
    } catch (e) {
      // Revert UI change if API call fails
      setState(() {
        isFavorite = !isFavorite;
      });
      // Also revert global state
      FavoriteManager.instance.updateSetFavorite(widget.ms_id, !isFavorite);
      widget.onFavoriteChanged(isFavorite);
      print("Error toggling favorite: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetMassageDetailPage(
              massageID: widget.ms_id,
              rating: "0", // You may want to add rating as a property if needed
            ),
          ),
        );
      },
      child: Container(
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
                  children: widget.images.length == 2
                      ? [
                          // Layout for 2 images
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                child: Image.network(
                                  widget.images[0],
                                  width: 65,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  widget.images[1],
                                  width: 65,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ]
                      : [
                          // Layout for 3 images
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                ),
                                child: Image.network(
                                  widget.images[0],
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
                                  widget.images[1],
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
                              widget.images[2],
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
                              "${widget.duration} นาที",
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
                              'บริเวณ: ${widget.types.join(", ")}',
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
      ),
    );
  }
}
