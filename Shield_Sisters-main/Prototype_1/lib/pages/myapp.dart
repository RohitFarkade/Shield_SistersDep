import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import '/pages/BottomNavigation.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  void _showMessage(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('The S.O.S Alert is sent'),
      duration: Duration(seconds: 2), // Message will disappear after 3 seconds
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Emergency help Needed ?',
                style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement SOS functionality
              },
              style: ElevatedButton.styleFrom(
                iconColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: ElevatedButton(onPressed: () => _showMessage(context),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(
                              side: BorderSide(color: Color(0xFFADDDC7), width: 8), // Add border color and width
                            ),
                            padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                            // backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "S.O.S",
                            style: TextStyle(fontSize: 50.0, color: Colors.red),
                          ),
                        )
                      ),],
                  ),

                ],),
            ),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildActionCard(context, 'Police', '100'),
                _buildActionCard(context, 'Women helpline', ''),
                _buildActionCard(context, 'Nearby help', ''),
                _buildActionCard(context, 'Alert Friends', ''),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle) {
    return Card(elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement action for this button
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }
}

