import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emergency Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EmergencyContactsPage(),
    );
  }
}

class EmergencyContactsPage extends StatefulWidget {
  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<Map<String, String>> contacts = [];
  bool isEditing = false;
  int contactsLimit = 5;

  void _addContact(String name, String phoneNumber) {
    if (contacts.length < contactsLimit) {
      setState(() {
        contacts.add({'name': name, 'phoneNumber': phoneNumber});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum contact limit exceeded.'),
        ),
      );
    }
  }

  void _showContactForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController phoneNumberController = TextEditingController();

        return AlertDialog(
          title: Text('Add Emergency Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _addContact(nameController.text, phoneNumberController.text);
                Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text('Emergency Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(contacts[index]['name'] ?? ''),
            subtitle: Text(contacts[index]['phoneNumber'] ?? ''),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactForm,
        tooltip: 'Add Emergency Contact',
        child: Icon(Icons.edit),
      ),
    );
  }
}
