
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding Screen'),
      ),
      body: PageView(
        children: [
          buildPage(
            title: 'Welcome',
            description: 'This is the first onboarding page.',
            image: '#', // Replace with your image path
          ),
          buildPage(
            title: 'Discover',
            description: 'This is the second onboarding page.',
            image: '#',
          ),
          buildPage(
            title: 'Get Started',
            description: 'This is the third onboarding page.',
            image: '#',
          ),
        ],
      ),
    );
  }

  Widget buildPage({required String title, required String description, required String image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image, height: 250), // Replace with correct image assets
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
