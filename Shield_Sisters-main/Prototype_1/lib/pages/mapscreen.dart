import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Set<Polygon> _createZones() {
    return {
      Polygon(
        polygonId: const PolygonId('safe_zone'),
        points: const [LatLng(20.59, 78.96), LatLng(20.58, 78.97)],
        strokeColor: Colors.green,
        fillColor: Colors.green.withOpacity(0.3),
      ),
      Polygon(
        polygonId: const PolygonId('unsafe_zone'),
        points: const [LatLng(19.926761, 79.316468), LatLng(19.924793, 79.324047),LatLng(19.917058, 79.321737),LatLng(19.921401, 79.314808) ],
        strokeColor: Colors.red,
        fillColor: Colors.red.withOpacity(0.3),
      ),
    };
  }
  final LatLng _center = const LatLng(19.921676, 79.319563);
  final LatLng _center2 = const LatLng(21.464860, 78.447430);
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(20.5937, 78.9629); // Default to India

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14.0,
        ),
        circles: {
          Circle(
            circleId: const CircleId('safe_zone'),
            center: _center,
            radius: 500, // radius in meters
            fillColor: Colors.red.withOpacity(0.5),
            strokeColor: Colors.red,
            strokeWidth: 2,
          ),
          Circle(
            circleId: const CircleId('safe_zone'),
            center: _center2,
            radius: 500, // radius in meters
            fillColor: Colors.green.withOpacity(0.5),
            strokeColor: Colors.green,
            strokeWidth: 2,
          ),
        },
        // polygons: _createZones(),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
