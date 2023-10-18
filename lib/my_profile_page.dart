import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String firstName = 'John';
  String lastName = 'Doe';
  String email = 'johndoe@email.com';
  String phoneNumber = '123-456-7890';

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  bool isEditing = false;
  File? profilePictureFile;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs =
        await SharedPreferences.getInstance(); // Initialize SharedPreferences
    if (mounted) {
      await loadProfileData();
    }
  }

  Future<void> loadProfileData() async {
    setState(() {
      firstName = prefs.getString('firstName') ?? firstName;
      lastName = prefs.getString('lastName') ?? lastName;
      email = prefs.getString('email') ?? email;
      phoneNumber = prefs.getString('phoneNumber') ?? phoneNumber;
      // Load the profile picture file here if available
    });
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

    // Show a bottom sheet to let the user choose between gallery and camera.
    final pickedSource = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Camera'),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
        ],
      ),
    );

    // If the user selected a source, pick an image from that source.
    if (pickedSource != null) {
      final pickedFile = await picker.pickImage(
        source: pickedSource,
      );

      if (pickedFile != null) {
        _updateProfilePicture(File(pickedFile.path));
      }
    }
  }

  void _updateProfilePicture(File? pickedFile) {
    setState(() {
      profilePictureFile = pickedFile;
    });
  }

  Future<void> saveChanges() async {
    await prefs.setString('firstName', firstNameController.text);
    await prefs.setString('lastName', lastNameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phoneNumber', phoneNumberController.text);

    setState(() {
      isEditing = false;
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
                        ? FileImage(profilePictureFile!)
                        : AssetImage('assests/profileimg/')
                            as ImageProvider<Object>,
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
