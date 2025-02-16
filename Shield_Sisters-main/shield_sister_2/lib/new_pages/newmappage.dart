import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Landmark {
  String name;
  String description;
  LatLng location;

  Landmark({
    required this.name,
    required this.description,
    required this.location,
  });
}

Future<List<Landmark>> fetchLandmarks(LatLng location, String type) async {
  const apiKey =
      "AIzaSyBOQVoXhw3B9sGlfpiOJNzqYng59AYRtUM"; // Replace with your API key

  final url =
      Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
          'location=${location.latitude},${location.longitude}'
          '&radius=1000' // Set radius to 1 km
          '&type=$type' // Fetch specified type
          '&key=$apiKey');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;

      return results.map<Landmark>((result) {
        final name = result['name'] as String? ?? 'Unknown';
        final description =
            result['vicinity'] as String? ?? 'No description available';
        final location = LatLng(
          result['geometry']['location']['lat'] as double? ?? 0.0,
          result['geometry']['location']['lng'] as double? ?? 0.0,
        );

        return Landmark(
          name: name,
          description: description,
          location: location,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch landmarks: ${response.reasonPhrase}');
    }
  } catch (error) {
    print('Error fetching landmarks: $error');
    return []; // Return an empty list in case of an error
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(20.5937, 78.9629);
  LatLng _pastPosition = const LatLng(20.5937, 78.9629);
  final Set<Circle> _circles = {};
  final List<Landmark> safeZones =
      []; // List of safe zones (hospitals and police stations)
  final List<LatLng> unsafeZoneCenters = []; // List of unsafe zone centers
  String _zoneStatus = ''; // To display the zone status
  Set<Polyline> _polylines = {}; // To show directions as polylines
  bool _showZoneStatus = false; // To control the display of zone status
  Landmark? _selectedSafeZone; // To store the selected safe zone
  Color zoneColor = Colors.grey;
  final ValueNotifier<bool> globalNotifier = ValueNotifier(false);

  bool isCameraMoved = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _pastPosition = _initialPosition;
  }

  Future<void> _getUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _pastPosition = _initialPosition;
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
      await _updateZones(position); // Update zones based on user location
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _updateZones(Position position) async {
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    try {
      // Fetch hospitals and police stations
      List<Landmark> hospitals = await fetchLandmarks(userLocation, 'hospital');
      List<Landmark> policeStations =
          await fetchLandmarks(userLocation, 'police');

      print('Fetched hospitals: ${hospitals.length}');
      print('Fetched police stations: ${policeStations.length}');

      setState(() async {
        _circles.clear(); // Clear previous circles
        safeZones.clear();
        unsafeZoneCenters.clear();

        // Add circles for hospitals and police stations (safe zones)
        for (var hospital in hospitals) {
          _circles.add(Circle(
            circleId: CircleId(hospital.name), // Unique ID for the circle
            center: hospital.location,
            radius: 50, // radius in meters
            fillColor: Colors.green.withOpacity(0.5),
            strokeColor: Colors.green,
            strokeWidth: 2,
          ));
          safeZones.add(hospital); // Add to safe zones
        }

        for (var policeStation in policeStations) {
          _circles.add(Circle(
            circleId: CircleId(policeStation.name), // Unique ID for the circle
            center: policeStation.location,
            radius: 50, // radius in meters
            fillColor: Colors.green.withOpacity(0.5),
            strokeColor: Colors.green,
            strokeWidth: 2,
          ));
          safeZones.add(policeStation); // Add to safe zones
        }

        // Fetch liquor stores and bars (unsafe zones)
        List<Landmark> liquorStores =
            await fetchLandmarks(userLocation, 'liquor_store');
        List<Landmark> bars = await fetchLandmarks(userLocation, 'bar');

        print('Fetched liquor stores: ${liquorStores.length}');
        print('Fetched bars: ${bars.length}');

        // Add circles for liquor stores and bars (unsafe zones)
        for (var liquorStore in liquorStores) {
          _circles.add(Circle(
            circleId: CircleId(liquorStore.name), // Unique ID for the circle
            center: liquorStore.location,
            radius: 50, // radius in meters
            fillColor: Colors.red.withOpacity(0.5),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ));
          unsafeZoneCenters.add(liquorStore.location); // Add to unsafe zones
        }

        for (var bar in bars) {
          _circles.add(Circle(
            circleId: CircleId(bar.name), // Unique ID for the circle
            center: bar.location,
            radius: 50, // radius in meters
            fillColor: Colors.red.withOpacity(0.5),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ));
          unsafeZoneCenters.add(bar.location); // Add to unsafe zones
        }

        _checkUserZone(
            userLocation); // Check if user is in a safe or unsafe zone
      });
    } catch (e) {
      print('Error updating zones: $e');
    }
  }

  void _checkUserZone(LatLng userLocation) {
    bool inSafeZone = safeZones.any((zone) {
      return _calculateDistance(userLocation, zone.location) <= 50; // 50 meters
    });

    bool inUnsafeZone = unsafeZoneCenters.any((center) {
      return _calculateDistance(userLocation, center) <= 50; // 50 meters
    });

    setState(() {
      if (inSafeZone && inUnsafeZone) {
        // If the user is in both zones
        _zoneStatus =
            'You are in both a safe zone and an unsafe zone (Yellow Zone)';
        zoneColor = Colors.yellow;
      } else if (inSafeZone) {
        // If the user is only in a safe zone
        _zoneStatus = 'You are in a safe zone (Green Zone)';
        zoneColor = Colors.green;
      } else if (inUnsafeZone) {
        // If the user is only in an unsafe zone
        _zoneStatus = 'You are in an unsafe zone (Red Zone)';
        zoneColor = Colors.red;
      } else {
        // If the user is in neither zone
        _zoneStatus = 'You are in a neutral zone';
        zoneColor = Colors.grey;
      }
    });
  }

  double _calculateDistance(LatLng loc1, LatLng loc2) {
    const double earthRadius = 6371000; // meters
    double dLat = _degreesToRadians(loc2.latitude - loc1.latitude);
    double dLon = _degreesToRadians(loc2.longitude - loc1.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(loc1.latitude)) *
            cos(_degreesToRadians(loc2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    final url = Uri.parse('https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${origin.latitude},${origin.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=AIzaSyBOQVoXhw3B9sGlfpiOJNzqYng59AYRtUM' // Replace with your API key
        );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final routes = data['routes'];
      if (routes.isNotEmpty) {
        final polyline = routes[0]['overview_polyline']['points'];
        return decodePolyline(polyline);
      } else {
        throw 'No route found';
      }
    } else {
      throw 'Failed to load directions';
    }
  }

  List<LatLng> decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int result = 0;
      int shift = 0;
      int byte;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dLat = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lat += dLat;

      result = 0;
      shift = 0;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dLng = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lng += dLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            circles: _circles,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onCameraIdle: () => {_getUserLocation()},
            onCameraMove: (camera_position) => {
              if (_calculateDistance(_pastPosition, _initialPosition) > 500)
                {_getUserLocation(), _polylines.clear()}
            },
            padding: const EdgeInsets.only(
                bottom: 150), // Leave space for bottom buttons
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16, // Position above the bottom navigation bar
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showZoneStatus = !_showZoneStatus;
                          if (_showZoneStatus) {
                            Timer(Duration(seconds: 3), () {
                              setState(() {
                                _showZoneStatus = !_showZoneStatus;
                              });
                            });
                          }
                          _checkUserZone(
                              _initialPosition); // Check if the user is in a safe or unsafe zone
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: zoneColor, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: const Icon(
                          Icons.security,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Show directions to the selected safe zone
                          if (_selectedSafeZone != null) {
                            List<LatLng> route = await getDirections(
                                _initialPosition, _selectedSafeZone!.location);
                            setState(() {
                              _polylines.clear();
                              _polylines.add(Polyline(
                                polylineId: PolylineId('route'),
                                points: route,
                                color: Colors.blue,
                                width: 5,
                              ));
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: const Icon(
                          Icons.directions,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<Landmark>(
                    hint: const Text("Select Safe Zone"),
                    value: safeZones.contains(_selectedSafeZone)
                        ? _selectedSafeZone
                        : null,
                    onChanged: (Landmark? newValue) {
                      setState(() {
                        _selectedSafeZone = newValue;
                      });
                    },
                    items: safeZones.isNotEmpty
                        ? safeZones.map((Landmark zone) {
                            return DropdownMenuItem<Landmark>(
                              value: zone,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.7, // Adjust the width as needed
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        children: [
                                          Text(
                                            zone.name,
                                            style: GoogleFonts.nunito(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow
                                                .ellipsis, // Prevent text overflow
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${(_calculateDistance(zone.location, _initialPosition) / 1000).toStringAsFixed(2)}km',
                                      style: GoogleFonts.nunito(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        : [
                            DropdownMenuItem<Landmark>(
                              enabled: false,
                              value: Landmark(
                                  name: "No Safe Zones Nearby",
                                  description: "",
                                  location: _initialPosition),
                              child: Text("No Safe Zones"),
                            ),
                          ],
                  ),
                  // DropdownButton<Landmark>(
                  //   hint: const Text("Select Safe Zone"),
                  //   value: _selectedSafeZone,
                  //   onChanged: (Landmark? newValue) {
                  //     setState(() {
                  //       _selectedSafeZone = newValue;
                  //     });
                  //   },
                  //   items: safeZones.isNotEmpty
                  //   ?safeZones.map((Landmark zone) {
                  //     return DropdownMenuItem<Landmark>(
                  //       value: zone,
                  //       child: SizedBox(
                  //           width: MediaQuery.of(context).size.width *
                  //               0.7, // Adjust the width as needed
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Expanded(
                  //                 child: Wrap(
                  //                   children: [
                  //                     Text(
                  //                       zone.name,
                  //                       style: GoogleFonts.nunito(
                  //                         fontSize: 18,
                  //                         fontWeight: FontWeight.w500,
                  //                       ),
                  //                       overflow: TextOverflow
                  //                           .ellipsis, // Prevent text overflow
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //               Text(
                  //                 '${(_calculateDistance(zone.location, _initialPosition) / 1000).toStringAsFixed(2)}km',
                  //                 style: GoogleFonts.nunito(
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.bold,
                  //                 ),
                  //               )
                  //             ],
                  //           )),
                  //     );
                  //   }).toList()
                  //   : [
                  //     DropdownMenuItem<Landmark>(
                  //       enabled: false,
                  //       value: Landmark(name: "No Safe Zones Nearby", description: "", location: _initialPosition),
                  //       child: Text("No Safe Zones"),
                  //     ),
                  //     ]
                  // ),
                  // if (_showZoneStatus)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _zoneStatus,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MapScreen(),
  ));
}
