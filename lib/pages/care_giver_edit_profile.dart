import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CareGiverEditProfile extends StatefulWidget {
  const CareGiverEditProfile({Key? key}) : super(key: key);
  @override
  State<CareGiverEditProfile> createState() => _CareGiverEditProfileState();
}

class _CareGiverEditProfileState extends State<CareGiverEditProfile> {
  //getting the current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  File? _selectedImage;

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  //get the current user data
  Future<void> getUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('usersv2')
        .doc(currentUser.email)
        .get();

    _emailController.text = userData.get('email') as String;
    _firstNameController.text = userData.get('First Name') as String;
    _lastNameController.text = userData.get('Last Name') as String;
    _mobileController.text = userData.get('Mobile Phone') as String;
    _birthdayController.text = userData.get('birthday') as String;
    _addressController.text = userData.get('address') as String;
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  //profile picture uploader
  Future<void> uploadProfileImage(String userEmail) async {
    if (_selectedImage != null) {
      final fileName = '$userEmail-${DateTime.now().millisecondsSinceEpoch}';

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$fileName.jpg');

        final uploadTask = storageRef.putFile(_selectedImage!);

        // Wait for the upload to complete
        await uploadTask.whenComplete(() async {
          // Get the download URL of the uploaded image
          final downloadURL = await storageRef.getDownloadURL();

          // Store the mapping of user email to the unique file name in Firestore
          await FirebaseFirestore.instance
              .collection('usersv2')
              .doc(userEmail)
              .update({
            'imageFileName': fileName,
            'imageUrl': downloadURL,
          });

          //Show a snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image uploaded'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      //Show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Uploading image...'),
          backgroundColor: Colors.yellow,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      await uploadProfileImage(currentUser.email!);
    } else {
      print('Error picking image');
    }
  }

  //datepicker for birthday  method
  Future<void> _selectBirthday(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      _birthdayController.text =
          "${pickedDate.toLocal()}".split(' ')[0]; // Format the selected date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.black,
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      // Text f
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('usersv2')
              .doc(currentUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.exists) {
                return ListView(padding: const EdgeInsets.all(16), children: [
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                            snapshot.data!.get('imageUrl') as String),
                        child: IconButton(
                          padding: const EdgeInsets.only(top: 100),
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.black54,
                          ),
                          onPressed: _pickImage,
                          iconSize: 20,
                        ),
                      ),
                    ),

                    //First Name
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),

                    //Last Name
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),

                    //Email
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),

                    //Mobile
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        controller: _mobileController,
                        decoration: const InputDecoration(
                          labelText: 'Mobile',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          return null;
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: GestureDetector(
                        onTap: () => _selectBirthday(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _birthdayController,
                            decoration: const InputDecoration(
                              labelText: 'Birthday',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your birthday';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    //Address
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                    ),

                    //Save Button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('usersv2')
                              .doc(currentUser.email)
                              .update({
                            'First Name': _firstNameController.text,
                            'Last Name': _lastNameController.text,
                            'email': _emailController.text,
                            'Mobile Phone': _mobileController.text,
                            'birthday': _birthdayController.text,
                            'address': _addressController.text,
                            'bio': _bioController.text,
                          });
                          //Show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ])
                ]);
              } else {
                return const Center(
                  child: Text('No data found'),
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
