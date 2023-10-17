import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import 'dart:io' for File class

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String firstName = 'John'; // Replace with user data
  String lastName = 'Doe'; // Replace with user data
  String email = 'johndoe@email.com'; // Replace with user data
  String phoneNumber = '123-456-7890'; // Replace with user data

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool isEditing = false;
  File? profilePictureFile; // Use File from dart:io

  @override
  void initState() {
    super.initState();
    firstNameController.text = firstName;
    lastNameController.text = lastName;
    emailController.text = email;
    phoneNumberController.text = phoneNumber;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> pickProfilePicture() async {
    final picker = ImagePicker();

    // Show options to select from camera or gallery
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Choose an option"),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                _updateProfilePicture(pickedFile);
              },
              child: Text("Pick from Gallery"),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                _updateProfilePicture(pickedFile);
              },
              child: Text("Take a Photo"),
            ),
          ],
        );
      },
    );
  }

  void _updateProfilePicture(XFile? pickedFile) {
    setState(() {
      profilePictureFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void saveChanges() {
    // Implement the logic to save the changes
    setState(() {
      isEditing = false;
      // Update the values with the edited text
      firstName = firstNameController.text;
      lastName = lastNameController.text;
      email = emailController.text;
      phoneNumber = phoneNumberController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          isEditing
              ? IconButton(
                  icon: Icon(Icons.save),
                  onPressed: saveChanges,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: toggleEditing,
                ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: isEditing ? pickProfilePicture : null,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profilePictureFile != null
                        ? FileImage(profilePictureFile!) as ImageProvider
                        : AssetImage(
                            'assets/profile_picture.jpg'), // Provide a default image asset
                  ),
                ),
                if (isEditing)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt),
                  ),
              ],
            ),
          ),
          buildEditableField('First Name', firstNameController, Icons.person),
          buildEditableField('Last Name', lastNameController, Icons.person),
          buildEditableField('Email', emailController, Icons.email),
          buildEditableField(
              'Phone Number', phoneNumberController, Icons.phone),
        ],
      ),
    );
  }

  Widget buildEditableField(
      String title, TextEditingController controller, IconData icon) {
    return ListTile(
      title: Text(title),
      subtitle: isEditing
          ? TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Enter $title',
              ),
            )
          : Text(controller.text),
    );
  }
}
