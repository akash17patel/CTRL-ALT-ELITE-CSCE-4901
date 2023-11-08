import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  ImagePicker _imagePicker = ImagePicker();
  File? _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isEditing = false; // Track editing mode

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
        source: source); // Use the correct method pickImage

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _showImageSourceOptions() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.photo_library,
                      color: Color.fromARGB(255, 73, 153, 36),
                    ),
                    title: Text(
                      'Gallery',
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 153, 36),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: Color.fromARGB(255, 73, 153, 36),
                    ),
                    title: Text(
                      'Camera',
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 153, 36),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (isEditing) {
                // Handle the save action here
                // You can access the edited data from the controllers
              }
              toggleEditing();
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: isEditing ? _showImageSourceOptions : null,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 60, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Text('Name:'),
                  subtitle: isEditing
                      ? TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your name',
                          ),
                        )
                      : Text(nameController.text), // Display the saved name
                ),
                ListTile(
                  title: Text('Last Name:'),
                  subtitle: isEditing
                      ? TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            hintText: 'Enter your last name',
                          ),
                        )
                      : Text(lastNameController
                          .text), // Display the saved last name
                ),
                ListTile(
                  title: Text('Email:'),
                  subtitle: isEditing
                      ? TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                          ),
                        )
                      : Text(emailController.text), // Display the saved email
                ),
                ListTile(
                  title: Text('Phone Number:'),
                  subtitle: isEditing
                      ? TextFormField(
                          controller: phoneNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter your phone number (000-000-0000)',
                          ),
                        )
                      : Text(phoneNumberController
                          .text), // Display the saved phone number
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
