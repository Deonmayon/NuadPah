import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/api/auth.dart';
import 'package:frontend/pages/setMassageDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/massage.dart';
import '../utils/favorite_manager.dart'; // Add this import
import 'dart:async';
import 'dart:convert'; // Add this import

class MassageCardSet extends StatefulWidget {
  final int msID;
  final String title;
  final String description;
  final List<String> types;
  final int duration;
  final List<dynamic> images;
  final String? rating;
  final Function(bool) onFavoriteChanged;

  const MassageCardSet({
    Key? key,
    required this.msID,
    required this.title,
    required this.description,
    required this.types,
    required this.duration,
    required this.images,
    required this.rating,
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

  String userEmail = '';

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
    final favoriteStatus = FavoriteManager.instance.isSetFavorite(widget.msID);
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
        isFavorite = favmassages.contains(widget.msID);
      });
    }
  }

  Future<void> loadData() async {
    // Start both operations in parallel
    final userDataFuture = getUserData();
    // Check cached favorites while waiting for email
    await _checkCachedFavorites();

    await userDataFuture;

    // Only proceed if we have a valid email
    if (userData['email'].isNotEmpty) {
      // Fetch favorites data in background
      fetchMassages();
    }
  }

  // Fetch user data from local storage
  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedUserData = prefs.getString('userData');
    final decodedUserData = cachedUserData != null
        ? jsonDecode(cachedUserData)
        : {
            'email': '',
            'first_name': '',
            'last_name': '',
            'image_name': '',
            'role': '',
          };
    setState(() {
      userData = decodedUserData;
      userEmail = decodedUserData['email'];
    });
  }

  // Future<void> getUserEmail() async {
  //   if (!mounted) return;
  //   final apiService = AuthApiService();

  //   // Try to load from local storage first for immediate response
  //   final prefs = await SharedPreferences.getInstance();
  //   final cachedEmail = prefs.getString('userEmail');
  //   final token = prefs.getString('token');

  //   if (cachedEmail != null && cachedEmail.isNotEmpty) {
  //     setState(() {
  //       userData['email'] = cachedEmail;
  //     });
  //   }

  //   if (token == null) {
  //     print("Token is null, user not logged in.");
  //     return;
  //   }

  //   // Try up to 3 times with exponential backoff
  //   for (int attempt = 1; attempt <= 3; attempt++) {
  //     try {
  //       final response = await apiService.getUserData(token).timeout(
  //         Duration(seconds: 10),
  //         onTimeout: () {
  //           throw TimeoutException('Request timed out');
  //         },
  //       );

  //       if (mounted) {
  //         setState(() {
  //           userData = response.data;
  //         });
  //         // Cache email for faster future loads
  //         prefs.setString('userEmail', userData['email']);
  //         return; // Success - exit the function
  //       }
  //     } catch (e) {
  //       print("Error fetching user data (attempt $attempt): ${e.toString()}");
  //       if (attempt == 3) {
  //         // Final attempt failed
  //         return;
  //       }
  //       // Wait with exponential backoff before retrying
  //       await Future.delayed(Duration(milliseconds: 500 * attempt));
  //     }
  //   }
  // }

  Future<void> fetchMassages() async {
    if (userData['email'].isEmpty || !mounted) return;

    final apiService = MassageApiService();

    // Try up to 3 times with exponential backoff
    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        final response = await apiService.getFavSet(userData['email']).timeout(
          Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException('Request timed out');
          },
        );

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
            isFavorite = favmassages.contains(widget.msID);
          });
          return; // Success - exit the function
        }
      } catch (e) {
        print(
            "Error fetching set massages (attempt $attempt): ${e.toString()}");
        if (attempt == 3) {
          // Final attempt failed
          return;
        }
        // Wait with exponential backoff before retrying
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
  }

  Future<void> toggleFavorite() async {
    final apiService = MassageApiService();
    bool originalFavoriteState = isFavorite;
    bool apiCallSuccessful = false;
    int retryCount = 0;

    // Update UI immediately for responsiveness
    setState(() {
      isFavorite = !isFavorite;
    });
    widget.onFavoriteChanged(isFavorite);

    // Update the global favorite state
    FavoriteManager.instance.updateSetFavorite(widget.msID, isFavorite);

    // Save what we're about to do to handle retries properly
    final isAddingFavorite = isFavorite;

    while (!apiCallSuccessful && retryCount < 3) {
      try {
        // Then perform the API call with timeout
        if (isAddingFavorite) {
          await apiService.favSet(userData['email'], widget.msID).timeout(
            Duration(seconds: 15), // Increase timeout slightly
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
          apiCallSuccessful = true;
        } else {
          await apiService.unfavSet(userData['email'], widget.msID).timeout(
            Duration(seconds: 15), // Increase timeout slightly
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );
          apiCallSuccessful = true;
        }

        // Update cached favorites on success
        if (apiCallSuccessful) {
          if (isAddingFavorite && !favmassages.contains(widget.msID)) {
            favmassages.add(widget.msID);
          } else if (!isAddingFavorite) {
            favmassages.remove(widget.msID);
          }

          final prefs = await SharedPreferences.getInstance();
          prefs.setStringList('cachedSetFavorites',
              favmassages.map((id) => id.toString()).toList());
        }
      } catch (e) {
        retryCount++;
        String errorMsg = e.toString();

        // For 499 errors (client closed request), we'll try again
        if (errorMsg.contains('499') ||
            errorMsg.contains('ClientClosedRequest')) {
          print("Client closed request error (attempt $retryCount): $errorMsg");

          // Wait slightly longer between retries
          await Future.delayed(Duration(milliseconds: 800 * retryCount));

          // If this was our last retry and still failed
          if (retryCount >= 3 && !apiCallSuccessful) {
            print("Failed to toggle favorite after 3 attempts: $errorMsg");
            // Queue the operation to be retried later when app reopens
            _queueFailedFavoriteOperation(isAddingFavorite);
            _revertUiChange(originalFavoriteState);
          }
        } else {
          // For other errors, we'll revert immediately after first attempt
          print("Error toggling favorite: $errorMsg");
          _revertUiChange(originalFavoriteState);
          break; // Exit the retry loop for non-499 errors
        }
      }
    }
  }

  // Helper method to revert UI changes on failure
  void _revertUiChange(bool originalState) {
    if (mounted) {
      setState(() {
        isFavorite = originalState;
      });
      // Also revert global state
      FavoriteManager.instance.updateSetFavorite(widget.msID, originalState);
      widget.onFavoriteChanged(originalState);
    }
  }

  // Queue failed operation to be retried when app reopens
  Future<void> _queueFailedFavoriteOperation(bool isAddingFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> pendingSetFavoriteOps =
        prefs.getStringList('pendingSetFavoriteOps') ?? [];

    String operation = isAddingFavorite
        ? "add:${widget.msID}:${userData['email']}"
        : "remove:${widget.msID}:${userData['email']}";

    // Add to pending operations if not already there
    if (!pendingSetFavoriteOps.contains(operation)) {
      pendingSetFavoriteOps.add(operation);
      await prefs.setStringList('pendingSetFavoriteOps', pendingSetFavoriteOps);
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
                massageID: widget
                    .msID // You may want to add rating as a property if needed
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
