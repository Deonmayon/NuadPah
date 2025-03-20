import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/reviewsWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}


class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location _locationController = new Location();
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final String _placesApiKey = "AIzaSyCN5n-i2muyF01pUKT9dMxquw1MKxbJt0Y";

  Map<String, dynamic>? selectedMarker;
  String? selectedMarkerPhotoUrl;
  List<dynamic>? selectedMarkerReviews;

  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  double _zoom = 12.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchSpaLocations();
  }

  Future<void> _cameraToPosition(LatLng position) async {
    CameraPosition newPosition = CameraPosition(
      target: position,
      zoom: _zoom,
    );
    await mapController
        .animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  Future<void> _getNewPosition(LatLng position) async {
    setState(() {
      _currentPosition = position;
    });
    _cameraToPosition(_currentPosition!);
    _fetchSpaLocations();
  }

  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentPosition);
        });
      }
    });
  }

  Future<void> _fetchSpaLocations() async {
    if (_currentPosition == null) return;

    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=5000&keyword=spa&key=$_placesApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      // สร้าง markers ก่อนเรียก setState
      final Set<Marker> newMarkers = {};
      newMarkers.add(Marker(
        markerId: MarkerId('myLocation'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: _currentPosition!,
        infoWindow: InfoWindow(
          title: 'My Location',
          snippet: 'Current Location',
        ),
      ));

      for (var place in results) {
        final location = place['geometry']['location'];
        final marker = Marker(
          markerId: MarkerId(place['place_id']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(location['lat'], location['lng']),
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: place['vicinity'],
          ),
          onTap: () {
            _fetchPlaceDetails(place['place_id']); // ดึงข้อมูลเพิ่มเติม
            _showDetailplacePopup(place); // แสดง bottom sheet
            // setState(() {
            //   selectedMarker = place;
            // });
          },
        );
        newMarkers.add(marker);
      }

      // เรียก setState เพียงครั้งเดียว
      setState(() {
        _markers.clear();
        _markers.addAll(newMarkers);
      });
    }
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,formatted_address,photos,reviews&key=$_placesApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final place = data['result'];

      setState(() {
        selectedMarker = place;
      });

      // ดึงรูปภาพ
      if (place['photos'] != null && place['photos'].isNotEmpty) {
        final photoReference = place['photos'][0]['photo_reference'];
        final photoUrl = await _getPhotoUrl(photoReference);
        setState(() {
          selectedMarkerPhotoUrl = photoUrl;
        });
      }

      // ดึงรีวิว
      if (place['reviews'] != null && place['reviews'].isNotEmpty) {
        setState(() {
          selectedMarkerReviews = place['reviews'];
        });
      }
    }
  }

  Future<String?> _getPhotoUrl(String photoReference) async {
    final String photoUrl =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$_placesApiKey";
    return photoUrl;
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ให้ bottom sheet ขยายเต็มหน้าจอ
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedMarkerPhotoUrl != null)
                  Image.network(selectedMarkerPhotoUrl!),
                Text(
                  place['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Rating: ${place['rating']} / 5 (${place['user_ratings_total']})',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  place['formatted_address'] ?? 'No address available',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                if (selectedMarkerReviews != null)
                  ReviewsWidget(
                      reviews:
                          selectedMarkerReviews!), // เรียกใช้ ReviewsWidget
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetailplacePopup(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFFFF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                width: double.infinity,
                height: 450,
                color: const Color(0xFFFFFFFF),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 50,
                        decoration:
                            const BoxDecoration(color: Color(0xFFFFFFFF)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Name Location',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ),
                    ),
                    Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingStars(
                                rating: place['rating']?.toDouble() ?? 0.0,
                                reviewCount: place['user_ratings_total'] ?? 0,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 30,
                                width: 104,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC0A172),
                                  borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Direction',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/Massage_Image01.png',
                                width: 140,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Reviews',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ReviewCard(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(children: [
              GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: _zoom,
                  ),
                  markers: _markers,
                  onTap: (LatLng latLng) {
                    _getNewPosition(latLng);
                  },
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      _zoom = position.zoom;
                    });
                  }),
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    width: 372,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 15,
                          color: Color(0x3F000000),
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Color(0xFFB1B1B1),
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: textController,
                              focusNode: textFieldFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Color(0xFFB1B1B1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
      bottomNavigationBar: HomeBottomNavigationBar(
        initialIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
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
          const Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage:
                    AssetImage('assets/images/profilePicture.jpg'),
              ),
              SizedBox(width: 8),
              Text(
                'Cameron Williamson',
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
                padding:
                    const EdgeInsets.only(right: 5.0), // ระยะห่างระหว่างไอคอน
                child: Icon(
                  index < 4
                      ? FontAwesomeIcons.solidStar
                      : FontAwesomeIcons.star,
                  color: index < 4
                      ? const Color.fromRGBO(192, 161, 114, 1)
                      : Colors.grey,
                  size: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Lorem ipsum dolor sit amet,  occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Color.fromRGBO(103, 103, 103, 1),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingStars extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final Color starColor;

  const RatingStars({
    Key? key,
    required this.rating,
    required this.reviewCount,
    this.starColor = const Color(0xFFC0A172), // ทองอ่อน
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    int remainingStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(width: 5),
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: starColor, size: 18),

        if (hasHalfStar)
          Icon(Icons.star_half, color: starColor, size: 18),

        for (int i = 0; i < remainingStars; i++)
          const Icon(Icons.star_border, color: Colors.grey, size: 18),

        const SizedBox(width: 5),
        Text(
          "($reviewCount)", // จำนวนรีวิว
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}