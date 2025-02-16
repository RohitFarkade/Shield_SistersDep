import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/pages/map.dart';
import '/pages/myapp.dart';
import 'package:google_fonts/google_fonts.dart';
import '/pages/Profile_widgets.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //backgroundColor: Color(0xFFADDDC7),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          // Emergency Contacts
          SettingItem(
            icon: Icons.contacts,
            title: 'Emergency Contacts',
            subtitle: 'Manage trusted contacts for SOS alerts',
            onTap: () {
              // Navigate to Emergency Contacts Page
            },
          ),
          Divider(),

          // Notifications
          SettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Enable or disable app notifications',
            onTap: () {
              // Navigate to Notification Settings
            },
          ),
          Divider(),

          // Location Sharing
          SettingItem(
            icon: Icons.location_on,
            title: 'Location Sharing',
            subtitle: 'Enable live location for emergency situations',
            onTap: () {
              // Toggle Location Sharing
            },
          ),
          Divider(),

          // SOS Settings
          SettingItem(
            icon: Icons.warning_amber_rounded,
            title: 'SOS Settings',
            subtitle: 'Customize SOS trigger and alerts',
            onTap: () {
              // Navigate to SOS Settings Page
            },
          ),
          Divider(),

          // Privacy Settings
          SettingItem(
            icon: Icons.lock,
            title: 'Privacy Settings',
            subtitle: 'Manage data and privacy preferences',
            onTap: () {
              // Navigate to Privacy Settings Page
            },
          ),
          Divider(),

          // Help & Support
          SettingItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get support or learn more about the app',
            onTap: () {
              // Navigate to Help Page
            },
          ),
          Divider(),


        ],
      ),
    );
  }
}

// Reusable Setting Item Widget
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SettingItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blueGrey.withOpacity(0.3),
        child: Icon(icon, color: Colors.black),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[400]),
      ),
      onTap: onTap,
    );
  }
}
