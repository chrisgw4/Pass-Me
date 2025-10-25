

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pass_me/helper/helped_functions.dart';
import 'dart:typed_data';
import '../components/my_back_button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    Uint8List? _image;

  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  //current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //future for fetching details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Profile"),
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   elevation: 0,
      // ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          //error
          else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          //data got
          else if (snapshot.hasData) {
            //extract
            Map<String, dynamic>? user = snapshot.data!.data();

            return Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 25),
                    child: Row(children: [MyBackButton()]),
                  ),

                  const SizedBox(height: 25),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).colorScheme.primary,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   padding: EdgeInsets.all(25),
                  //   child: Icon(Icons.person, size: 64,),
                  // ),
                  Stack(
                    children: [
                      _image != null ?
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                      :
                      const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png',
                        ),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                        bottom: -10,
                        left: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    user!['username'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Text(
                    user!['email'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          } else {
            return Text("No data");
          }
        },
      ),
    );
  }
}
