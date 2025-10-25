import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/my_back_button.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //future for fetching details
Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async{
  return await FirebaseFirestore.instance.collection("User").doc(currentUser!.email).get();
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
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //error
          else if (snapshot.hasError){
            return Text("Error: ${snapshot.error}");
          }

          //data got
          else if(snapshot.hasData) {
            //extract
            Map<String,dynamic>? user = snapshot.data!.data();

            return Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50.0,
                      left: 25,
                    ),
                    child: Row(
                      children: [
                        MyBackButton(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25,),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(25),
                    child: Icon(Icons.person, size: 64,),
                  ),

                  const SizedBox(height: 25,),
                  Text(user!['username'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height: 5,),
                  Text(user!['email'],
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }else{
            return Text("No data");
          }

        },
      )
    );
  }
}
