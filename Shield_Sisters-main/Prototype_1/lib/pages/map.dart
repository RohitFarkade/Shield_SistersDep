import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/pages/AccountPage.dart';
import '/pages/myapp.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: const Text("Map Page",
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),

      body: const Column(
        children: [
          SizedBox(height: 275.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Map API", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 42.0, color: Colors.amber),)
          ],
        ),
      ],),

    );
  }
}