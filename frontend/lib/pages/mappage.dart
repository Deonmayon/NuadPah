import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/components/HomeButtomNavigationBar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(13.7563, 100.5018); // Bangkok, Thailand
  final Set<Marker> _markers = {};
  final String _placesApiKey = ""; // แทนที่ด้วย API Key ของคุณ
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchSpaLocations();
  }

  Future<void> _fetchSpaLocations() async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_initialPosition.latitude},${_initialPosition.longitude}&radius=5000&keyword=spa&key=$_placesApiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      setState(() {
        _markers.clear();
        for (var place in results) {
          final location = place['geometry']['location'];
          final marker = Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(location['lat'], location['lng']),
            infoWindow: InfoWindow(
              title: place['name'],
              snippet: place['vicinity'],
            ),
          );
          _markers.add(marker);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack (
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 12.0,
          ),
            markers: _markers,
          ),
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
      ]
    ),
      bottomNavigationBar: HomeBottomNavigationBar(
        initialIndex: 2,
        onTap: (index) {},
      ),
    );
  }
}