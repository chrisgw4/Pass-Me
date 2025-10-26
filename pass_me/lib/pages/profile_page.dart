

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pass_me/helper/helped_functions.dart';
import 'package:pass_me/resources/add_data.dart';
import 'dart:typed_data';
import '../components/my_back_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    late final CollectionReference _myCollection = _firestore.collection("User");


    Future<DocumentSnapshot> getSpecificDocument(String documentId) async {
      DocumentSnapshot documentSnapshot = await _myCollection.doc(documentId).get();
      if (documentSnapshot.exists)
        {
          return documentSnapshot;
        }
      else {
        return documentSnapshot;
      }
    }
    Uint8List? _image;
    Uint8List? _uptoimage;

  void selectImage() async{
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

    void selectUpToImage() async{
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _uptoimage = img;
      });
    }

  //current logged in user
    User? currentUser = FirebaseAuth.instance.currentUser;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController greetingController = TextEditingController();
    final TextEditingController upToController = TextEditingController();
    final TextEditingController questionController = TextEditingController();
  //future for fetching details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(currentUser!.email)
        .get();
  }
  void saveProfile() async {

    String name = nameController.text;
    String greeting = greetingController.text;
    String email = currentUser!.email.toString();
    String upto = upToController.text;
    String question = questionController.text;
    String resp = await StoreData().saveData(email: email, name: name, greeting: greeting, file: _image, uptoimage: _uptoimage, upto: upto, question: question);
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
            if (nameController.text == "") {
              nameController.text = snapshot.data?["username"];
            }

            if (greetingController.text == "") {
              greetingController.text = snapshot.data?["greeting"];
            }

            if (upToController.text == "") {
              upToController.text = snapshot.data?["upto"];
            }

            if (questionController.text == "") {
              questionController.text = snapshot.data?["question"];
            }

            return Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, left: 0),
                      child: Row(children: [MyBackButton()]),
                    ),




                     // The spacer that pushes the text down
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Your Profile",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //const SizedBox(height:24),
                    Stack(
                      children: [
                        _image != null ?
                            CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                        :
                        CircleAvatar(
                          radius: 64,

                          backgroundImage: NetworkImage(user?['pfpimage']),//NetworkImage(

                            //'https://icons.veryicon.com/png/o/miscellaneous/common-icons-31/default-avatar-2.png',
                          //),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                          ),

                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                      children: [
                        const SizedBox(height:8), // The spacer that pushes the text down
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Username",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      hintText: 'Enter Username',
                      contentPadding: EdgeInsets.all(10)),


                    ),

                    const SizedBox(height:8), // The spacer that pushes the text down
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Greeting",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 4,),
                    TextField(
                      controller: greetingController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter greeting',
                        contentPadding: EdgeInsets.all(10)),
                    ),

                    const SizedBox(height:8), // The spacer that pushes the text down
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "What I've Been Up To",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4,),

                    Stack(
                      children: [
                        _uptoimage != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the radius for desired corner roundness
                          child: Image.memory(
                            _uptoimage!,
                            width: 200, // Set width to 2 * radius (64 * 2) for consistency
                            height: 200, // Set height to 2 * radius (64 * 2) for consistency
                            fit: BoxFit.cover, // Ensures the image covers the area without distortion
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), // Adjust the radius for desired corner roundness
                          child: Image.network(
                            user?['uptoimage'],
                            width: 200, // Set width to 2 * radius (64 * 2) for consistency
                            height: 200, // Set height to 2 * radius (64 * 2) for consistency
                            fit: BoxFit.cover, // Ensures the image covers the area without distortion
                          ),
                        ),
                        Positioned(

                          child: IconButton(
                            onPressed: selectUpToImage,
                            icon: const Icon(Icons.add_a_photo),
                          ),
                          bottom: -15,
                          left: 160,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4,),
                    TextField(
                    controller: upToController,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'What Have You Been Up To?',
                    contentPadding: EdgeInsets.all(10)),
                    ),
                    const SizedBox(height:8), // The spacer that pushes the text down
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Question",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4,),
                    TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'What do you want to ask everyone?',
                          contentPadding: EdgeInsets.all(10)),
                    ),
                    const SizedBox(height: 15,),

              SizedBox(
                width: 200, // Makes the button full width
                height: 50, // Optional: Set a specific height
                child: ElevatedButton(
                  onPressed: saveProfile,
                  child: Text(
                    'Save Profile',
                    style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize:16),
                  ),
                ),
              ),
                  ],
                ),
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
