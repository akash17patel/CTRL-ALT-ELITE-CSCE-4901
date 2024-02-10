// import 'package:flutter/material.dart';

// class EmergencyContactPage extends StatefulWidget {
//   @override
//   _EmergencyContactPageState createState() => _EmergencyContactPageState();
// }

// class _EmergencyContactPageState extends State<EmergencyContactPage> {
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Emergency Contact"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Name"),
//             TextField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Text("Phone Number"),
//             TextField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // handle form submission
//                 },
//                 child: Text("Save"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class EmergencyContactPage extends StatefulWidget {
  @override
  _EmergencyContactPageState createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _contactsKey = GlobalKey<_ContactListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name"),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text("Phone Number"),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addContact();
                },
                child: Text("Save"),
              ),
            ),
            Expanded(
              child: ContactList(
                key: _contactsKey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      _contactsKey.currentState?.addContact(
        Contact(
          name: _nameController.text,
          phoneNumber: _phoneController.text,
        ),
      );
      _nameController.clear();
      _phoneController.clear();
    }
  }
}

class ContactList extends StatefulWidget {
  ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _contacts = <Contact>[];

  void addContact(Contact contact) {
    setState(() {
      _contacts.add(contact);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _contacts.length,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return ListTile(
          title: Text(contact.name),
          subtitle: Text(contact.phoneNumber),
          leading: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editContact(index, contact);
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteContact(index);
            },
          ),
        );
      },
    );
  }

  void _editContact(int index, Contact contact) {
    // Handle editing the contact
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }
}

class Contact {
  final String name;
  final String phoneNumber;

  Contact({
    required this.name,
    required this.phoneNumber,
  });
}