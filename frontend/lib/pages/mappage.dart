import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:frontend/components/reviewsWidget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

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
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
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
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=5000&keyword=spa&key=$_placesApiKey&language=th";

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
      ));

      for (var place in results) {
        final location = place['geometry']['location'];
        final marker = Marker(
          markerId: MarkerId(place['place_id']),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: LatLng(location['lat'], location['lng']),
          onTap: () {
            _fetchPlaceDetails(place['place_id']);
            _showDetailPlacePopup(place);
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
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,formatted_address,photos,reviews&key=$_placesApiKey&language=th";

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
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$_placesApiKey&language=th";
    return photoUrl;
  }

  Future<void> _launchMapsUrl(double lat, double lng, String title) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=${selectedMarker?['place_id']}');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  String limitTextLength(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  void _showDetailPlacePopup(Map<String, dynamic> place) {
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
                      decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              limitTextLength(
                                  place['name'] ?? 'ไม่ระบุชื่อ', 25),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  
                                  overflow: TextOverflow.ellipsis),
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
                              Text(
                                place['vicinity'] ?? 'ไม่ระบุที่อยู่',
                              ),
                              const SizedBox(height: 10),
                              RatingStars(
                                rating: place['rating']?.toDouble() ?? 0.0,
                                reviewCount: place['user_ratings_total'] ?? 0,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  _launchMapsUrl(
                                      place['geometry']['location']['lat'],
                                      place['geometry']['location']['lng'],
                                      place['name']);
                                },
                                child: Container(
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
                                        FontAwesomeIcons.diamondTurnRight,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'ไปยังแผนที่',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (selectedMarkerPhotoUrl != null)
                                Image.network(
                                  selectedMarkerPhotoUrl!,
                                  height: 200,
                                ),
                              const SizedBox(height: 20),
                              const Text(
                                'รีวิวของผู้ใช้งาน',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (selectedMarkerReviews != null)
                                ReviewsCard(reviews: selectedMarkerReviews!),
                              // ReviewCard(),
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
                            padding: const EdgeInsets.only(
                                left: 10, top: 2, right: 10),
                            child: TextFormField(
                              controller: textController,
                              focusNode: textFieldFocusNode,
                              decoration: InputDecoration(
                                hintText: 'ค้นหา',
                                hintStyle: const TextStyle(
                                  
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
            
          ),
        ),
        const SizedBox(width: 5),
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: starColor, size: 18),
        if (hasHalfStar) Icon(Icons.star_half, color: starColor, size: 18),
        for (int i = 0; i < remainingStars; i++)
          const Icon(Icons.star_border, color: Colors.grey, size: 18),
        const SizedBox(width: 5),
        Text(
          "($reviewCount)", // จำนวนรีวิว
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            
          ),
        ),
      ],
    );
  }
}
