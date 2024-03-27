import 'package:flutter/material.dart';
import 'services/database.dart';

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

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    List<Map<String, dynamic>> dbContacts = await MindliftDatabase.instance.fetchAllContacts();
    setState(() {
      contacts = dbContacts.map<Map<String, String>>((contact) => {
        'name': contact['name'] as String,
        'phone': contact['phone'] as String,
      }).toList();
    });
  }


  void _addContact(String name, String phoneNumber) async {
    if (contacts.length < contactsLimit) {
      // Format the phone number
      String formattedPhoneNumber = _formatPhoneNumber(phoneNumber);

      await MindliftDatabase.instance.insertContact({
        'name': name,
        'phone': formattedPhoneNumber,
      });

      // Reload contacts to include the new entry
      _loadContacts();
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
        // Controllers to capture input from text fields
        TextEditingController nameController = TextEditingController();
        TextEditingController phoneNumberController = TextEditingController();

        return AlertDialog(
          title: Text('Add Emergency Contact'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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

  String _formatPhoneNumber(String phoneNumber) {
    // Basic formatting to match xxx-xxx-xxxx
    var digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6, 10)}';
    }
    return phoneNumber; // Return original if not exactly 10 digits
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
        child: Icon(Icons.add),
      ),
    );
  }
}
