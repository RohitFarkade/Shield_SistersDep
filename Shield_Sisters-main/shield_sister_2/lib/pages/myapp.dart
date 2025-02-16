// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart'; // Import Geolocator
// import '/backend/Authentication.dart'; // Assuming the AuthService is in the backend folder
// import '/new_pages/mymap.dart'; // No changes made to your existing imports
// import '/new_pages/livepage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   double helpTextSize = 20;
//   String fontName = "Nunito";
//   int _currentIndex = 0;
//   final AuthService authService = AuthService();
//   String userId = ""; // Initialize as an empty string

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//   }

//   // Function to get user data from SharedPreferences
//   void getUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString('userId') ?? ""; // Update `userId` with the value from SharedPreferences
//     });
//   }

//   // Function to show a message after sending SOS
//   void _showMessage(BuildContext context, String message, {bool isError = false}) {
//     final snackBar = SnackBar(
//       content: Text(message),
//       backgroundColor: isError ? Colors.red : Colors.green,
//       duration: const Duration(seconds: 2),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   // Function to send SOS alert
//   void _sendSOS(BuildContext context) async {
//     // Get current location dynamically using Geolocator
//     Position position = await _getCurrentLocation();

//     if (position != null) {
//       final latitude = position.latitude.toString();
//       final longitude = position.longitude.toString();

//       final result = await authService.sendSOS(userId, latitude, longitude);

//       if (result['message'] == 'SOS sent successfully') {
//         _showMessage(context, 'The S.O.S alert was sent successfully');
//       } else {
//         _showMessage(
//           context,
//           result['message'] ?? 'Failed to send S.O.S alert',
//           isError: true,
//         );
//       }
//     } else {
//       _showMessage(context, 'Unable to retrieve location', isError: true);
//     }
//   }

//   // Function to get the current location
//   Future<Position> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Check if location services are enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     // Check for location permissions
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error('Location permissions are permanently denied');
//     }

//     // Get the current location
//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }

//   // Navigate to map page
//   void _navigateToMap(BuildContext context, String userId) {
//     Navigator.pushNamed(context, '/redirect', arguments: userId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Header Section
//             Text(
//               "Emergency Help Needed?",
//               style: TextStyle(
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 15),

//             // Subheader Section
//             Text(
//               "Alert family members, close ones, and police\nwith live location tracking",
//               style: TextStyle(
//                 fontSize: 16,
//                 height: 1.5,
//                 color: Colors.grey[600],
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 25),

//             // S.O.S Button
//             GestureDetector(
//               onTap: () => _sendSOS(context),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.red.withOpacity(0.3),
//                       blurRadius: 15,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: CircleAvatar(
//                   radius: 80,
//                   backgroundColor: Colors.redAccent,
//                   child: const Text(
//                     "S.O.S",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 34,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 2.0,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40),

//             // Action Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 buildActionButton(Icons.shield, "Police"),
//                 buildActionButton(Icons.phone, "Home"),
//                 buildActionButton(Icons.support, "Helpline"),
//                 buildActionButton(Icons.notifications_active, "Alert", onTap: () {
//                   _navigateToMap(context, userId); // Pass the user_id to the RedirectPage
//                 }),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper Widget to Build Action Buttons
//   Widget buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 5,
//                   offset: const Offset(2, 2),
//                 ),
//               ],
//             ),
//             child: Icon(
//               icon,
//               size: 30,
//               color: const Color(0xFF55CF9F),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import '/backend/Authentication.dart'; // Assuming the AuthService is in the backend folder
import '/new_pages/mymap.dart'; // No changes made to your existing imports
import '/new_pages/livepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:url_launcher/url_launcher.dart";

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _callPolice() async {
    Uri dialerUri = Uri(scheme: 'tel', path: '100'); // Blank tel: URI
    try {
      await launchUrl(dialerUri);
    } catch (e) {
      debugPrint('Error opening the dialer: $e');
    }
  }
  Future<void> _callhome() async {
    Uri dialerUri = Uri(scheme: 'tel'); // Blank tel: URI
    try {
      await launchUrl(dialerUri);
    } catch (e) {
      debugPrint('Error opening the dialer: $e');
    }
  }
  
  double helpTextSize = 20;
  String fontName = "Nunito";
  int _currentIndex = 0;
  final AuthService authService = AuthService();
  String userId = ""; // Initialize as an empty string

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  // Function to get user data from SharedPreferences
  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? ""; // Provide a default empty string if 'userId' is null
    });
  }

  // Function to show a message after sending SOS
  void _showMessage(BuildContext context, String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to send SOS alert
  void _sendSOS(BuildContext context) async {
    // Get current location dynamically using Geolocator
    Position position = await _getCurrentLocation();

    if (position != null) {
      final latitude = position.latitude.toString();
      final longitude = position.longitude.toString();

      final result = await authService.sendSOS(userId, latitude, longitude);

      if (result['message'] == 'SOS sent successfully') {
        _showMessage(context, 'The S.O.S alert was sent successfully');
      } else {
        _showMessage(
          context,
          result['message'] ?? 'Failed to send S.O.S alert',
          isError: true,
        );
      }
    } else {
      _showMessage(context, 'Unable to retrieve location', isError: true);
    }
  }

  // Function to get the current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Get the current location
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Navigate to map page
  void _navigateToMap(BuildContext context, String userId) {
    Navigator.pushNamed(context, '/redirect', arguments: userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header Section
            Text(
              "Emergency Help Needed?",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            // Subheader Section
            Text(
              "Alert family members, close ones, and police\nwith live location tracking",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            // S.O.S Button
            GestureDetector(
              onTap: () => _sendSOS(context),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.redAccent,
                  child: const Text(
                    "S.O.S",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildActionButton(Icons.shield, "Police",
                    (){
                      _callPolice();
                    },
                ),
                buildActionButton(Icons.phone, "Home",
                      (){
                  _callhome();
                      },
                ),
                buildActionButton(Icons.support, "Helpline",
                      (){
                  Navigator.pushNamed(context, "/helpline");
                      },
                ),
                buildActionButton(Icons.notifications_active, "Alert",
                      (){},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 
  // Helper Widget to Build Action Buttons
  Widget buildActionButton(IconData icon, String label, VoidCallback callback) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(onPressed: callback,
            icon: Icon(
              icon,
              size: 30,
              color: Color(0xFF55CF9F),
            ),)
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
