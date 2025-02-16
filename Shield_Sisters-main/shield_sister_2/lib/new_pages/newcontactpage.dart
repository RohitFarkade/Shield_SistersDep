
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shield_sister_2/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Contact {
  String name;
  String phone;

  Contact(this.name, this.phone);

  Map<String, String> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  String userId = "";
  void getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    userId = prefs.getString('userId') ?? ""; // Provide a default empty string if 'userId' is null
  });
}
  final List<Contact> contactList = [];
  final AuthService authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  
  final String apiUrl = "http://localhost:5000/api/sos/savecontacts"; // Replace with your backend URL

  void _addContact() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId') ?? ""; // Provide a default empty string if 'userId' is null
      

    if (name.isNotEmpty && phone.isNotEmpty) {
      Contact newContact = Contact(name, phone);

      // Send data to backend
      bool success = await _sendContactToBackend(userId,newContact);

      if (success) {
        setState(() {
          contactList.add(newContact);
        });
        _nameController.clear();
        _phoneController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(" Contact successfully added")),
        );
      } else {
        // Show error if contact addition fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add contact")),
        );
      }
    }
  }

  Future<bool> _sendContactToBackend(String userId, Contact contact) async {
     final result = await authService.SaveContact(userId,contact);
     print(result);
     // print(userId);
     if( result['message'] == "Contacts saved successfully!") {
       return true;
     } else {
       return false;
     }
  }

  void _deleteContact(int index) {
    setState(() {
      contactList.removeAt(index);
    });
  }

  void _editContact(int index) {
    _nameController.text = contactList[index].name;
    _phoneController.text = contactList[index].phone;

    setState(() {
      contactList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Contacts List",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Contact Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),


            Expanded(
              child: contactList.isEmpty
                  ? Center(
                child: Text(
                  "No Contact yet...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrangeAccent,
                        foregroundColor: Colors.white,
                        child: Text(
                          contactList[index].name[0].toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      title: Text(
                        contactList[index].name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        contactList[index].phone,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[700]),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Edit') {
                            _editContact(index);
                          } else if (value == 'Delete') {
                            _deleteContact(index);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete'),
                          ),
                        ],
                        icon: Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              ),
            ),

          
          ],
        ),
      ),
    );
  }
}
