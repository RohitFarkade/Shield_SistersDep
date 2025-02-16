import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/pages/SettingPage.dart';
import '/pages/AboutPage.dart';
import '/pages/FAQsPage.dart';
import 'loginpage.dart';
import 'accountpage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = ""; 
  String userEmail = ""; 

  void get_userdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
        userName = prefs.getString('username') ?? "";
        print(userName);
        userEmail = prefs.getString('email') ?? "";
        print(userEmail);
    });
  }

  @override
  void initState() {
    super.initState();
    get_userdata();
  }

  // Logout Confirmation Dialog
  void _logoutAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performLogout(context); // Perform logout action
              },
            ),
          ],
        );
      },
    );
  }

  // Perform logout logic (e.g., clear user data, redirect to login screen)
  void _performLogout(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    // Example navigation to Login Page
    Navigator.pushReplacementNamed(context, '/log');
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top row with Back Arrow and Settings Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Image with Shadow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 5,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage("https://img.freepik.com/premium-vector/women-beauty-face-clipart-vector-illustration_1123392-5133.jpg?semt=ais_hybrid"),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Name with Verification
                    SizedBox(
                      width: double.maxFinite,
                      child:  Center(
                        child: Text(
                          userName,
                          style: GoogleFonts.sourceCodePro(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Email
                    Text(
                      userEmail,
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 18,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 33),

                    // Profile Menu Options
                    SizedBox(
                      height: size.height * .7,
                      width: size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileWidget(
                            icon: Icons.person,
                            title: 'My Profile',
                            color: Colors.blueAccent,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AccountPage()),
                              );
                            },
                          ),
                          ProfileWidget(
                            icon: Icons.chat,
                            title: 'FAQs',
                            color: Colors.green,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const FAQsPage()),
                              );
                            },
                          ),
                          ProfileWidget(
                            icon: Icons.info_rounded,
                            title: 'About',
                            color: Colors.deepOrangeAccent,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AboutPage()),
                              );
                            },
                          ),
                          ProfileWidget(
                            icon: Icons.logout_outlined,
                            title: 'Log Out',
                            color: Colors.red,
                            onPressed: () {
                              _logoutAccount(context); // Call logout logic
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onPressed;

  const ProfileWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ListTile(
        leading: Icon(icon, color: color, size: 26),
        title: Text(
          title,
          style: GoogleFonts.openSans(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
        onTap: onPressed,
      ),
    );
  }
}
