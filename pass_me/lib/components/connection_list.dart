import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pass_me/components/my_connection.dart';

import '../helper/helped_functions.dart';
import '../pages/user_page.dart';
import 'my_back_button.dart';

class ConnectionList extends StatelessWidget {
  ConnectionList({super.key});

  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(

      child:
        StreamBuilder<QuerySnapshot>( // Add explicit type for better safety
          stream: FirebaseFirestore.instance.collection("User").doc(currentUser!.email).collection("Connections").snapshots(),
          builder: (context, snapshot) {
            //error
            if(snapshot.hasError) {
              // Note: displayMessageToUser might need 'await' if it returns a Future
              displayMessageToUser("Something went wrong", context);
              return const Center(child: Text("Error loading users."));
            }

            //loading
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if(snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No Users Found"));
            }

            // get all user
            final users = snapshot.data!.docs;

            // return ListView.builder(
            //     itemCount: users.length,
            //     itemBuilder: (context, index) {
            //       final user = users[index];
            //       print(user['email']);
            //       return Text("Deez");
            //     }
            // );
            return
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      // print(user.data());
                      // print(user.id);
                      return MyConnection(user.id);
                      }


                  ),


                );


            // final user = users[index];
            // return MyConnection(user['email']);
            // return Column(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(
            //         top: 50.0,
            //         left: 25,
            //       ),
            //     ),
            //     Expanded(
            //       child: ListView.builder(
            //           padding: const EdgeInsets.all(0),
            //           itemCount: users.length,
            //           itemBuilder: (context, index) {
            //             // indiv user get
            //             final user = users[index];
            //             return MyConnection(user['email']);
            //             return ListTile(
            //               title: Text(user['username']),
            //               subtitle: Text(user['email']),
            //
            //               onTap: () {
            //                 // Navigate to the new page and pass the DocumentSnapshot
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => UserPage(
            //                       userSnapshot: user, // user is already a DocumentSnapshot
            //                     ),
            //                   ),
            //                 );
            //               },
            //             );
            //           }
            //       ),
            //     ), // <-- Missing closing parenthesis was here
            //   ],
            // );
          }, // <-- Missing closing parenthesis was here
        ),

    );
  }
}
