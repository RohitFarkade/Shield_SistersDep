import 'package:flutter/material.dart';
import '/pages/loginpage.dart';
import '/pages/myapp.dart';
import '/pages/registerpage.dart';
import '/pages/OnboardingScreen.dart';
import '/pages/BottomNavigation.dart';

// Import Settings Page

void main() {
  runApp(MaterialApp(
    debugShowMaterialGrid: false,
    home: FinalView(),
    color: Colors.amber,
    debugShowCheckedModeBanner: false,

    routes: {
      "/bot": (context) =>  FinalView(),
      "/int": (context) =>  OnboardingScreen(),
      "/reg": (context) => const RegisterPage(),
      "/log": (context) => const MyLogin(),
      "/home": (context) => const MyApp(),

    },
  ));

}


class HomeScreen extends StatefulWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/onboarding'); // Navigate to Onboarding Screen
          },
          child: Text("Go to Onboarding"),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}



