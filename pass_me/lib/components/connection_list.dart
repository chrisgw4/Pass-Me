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



            return
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      // Color c = Theme.of(context).colorScheme.secondary;

                      // Container with bottom padding between users
                      return Container(
                        key: ValueKey(user.id),
                        padding: EdgeInsets.only(bottom: 10, top: 10, left: 5, right: 5),
                        child: MyConnection(user.id),
                      );
                      }
                  ),
                );
          },
        ),

    );
  }
}
