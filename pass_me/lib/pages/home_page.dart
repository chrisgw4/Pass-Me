import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../components/my_drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _myCollection = _firestore.collection("User");

  //logout user
  void logout(){
    FirebaseAuth.instance.signOut();
  }
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(currentUser!.email)
        .get();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      actions: [
        //logout button
        IconButton(onPressed: logout, icon: Icon(Icons.logout),
        ),
       ],
      ),

      // Drawer
      drawer: MyDrawer(

      ),
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //   Padding(
                          //   padding: const EdgeInsets.only(top: 50.0, left: 0),
                          //   child: Row(children: [MyBackButton()]),
                          // ),


                          // The spacer that pushes the text down
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Text(
                          //     "Your Profile",
                          //     style: const TextStyle(
                          //       fontSize: 30,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          // ),
                          //const SizedBox(height:24),
                          Stack(
                            children: [

                              CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    user?['pfpimage']),
                              ),



                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  user?['username'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                );
              }
              else {
                return Text("No data");
              }
            }
              ),
              );

  }
}