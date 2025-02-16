import 'package:flutter/material.dart';
import 'package:shield_sisters/pages/ProfilePage.dart';


class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  // Function to handle Edit Account (Navigate to Edit Page)
  void _editAccount(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Edit Account Page')),
    );
  }

  // Function to handle Change Password
  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to Change Password Page')),
    );
  }

  // Function to handle Update Photo
  void _updatePhoto(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Update Profile Photo Functionality')),
    );
  }

  // Function to handle Delete Account
  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account Deleted Successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20,40,20,0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft, // Aligns the row to the left
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 28,
                    ),
                    onPressed: () {
                      // Back navigation logic
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context); // Go back if a previous route exists
                      } else {
                        // Optionally handle when there's no previous screen
                        print("No previous screen to go back to.");
                      }
                    },
                  ),
                  const SizedBox(width: 8), // Adds spacing between the button and title
                  const Text(
                    'Account', // Title text
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),



            // Profile Photo
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/image7.jpg'), // Default Image
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _updatePhoto(context),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Account Details Section
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'johndoe@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // Buttons Section
            _buildAccountOption(
              context: context,
              icon: Icons.edit,
              title: 'Edit Account',
              onPressed: () => _editAccount(context),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(
              context: context,
              icon: Icons.lock,
              title: 'Change Password',
              onPressed: () => _changePassword(context),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(
              context: context,
              icon: Icons.photo_camera,
              title: 'Update Profile Photo',
              onPressed: () => _updatePhoto(context),
            ),
            const SizedBox(height: 10),
            _buildAccountOption(
              context: context,
              icon: Icons.delete,
              title: 'Delete Account',
              iconColor: Colors.black,
              onPressed: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget to Build Account Options
  Widget _buildAccountOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onPressed,
      ),
    );
  }
}
