import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),

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
                children: [
                  Text(user!['email']),
                  Text(user['username']),
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
