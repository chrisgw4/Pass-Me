import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pass_me/helper/helped_functions.dart';
import 'package:pass_me/pages/user_page.dart'; // Ensure this path is correct

import '../components/my_back_button.dart';


class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>( // Add explicit type for better safety
        stream: FirebaseFirestore.instance.collection("User").snapshots(),
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

          return Column(
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
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      // indiv user get
                      final user = users[index];

                      return ListTile(
                        title: Text(user['username']),
                        subtitle: Text(user['email']),

                        onTap: () {
                          // Navigate to the new page and pass the DocumentSnapshot
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserPage(
                                userSnapshot: user, // user is already a DocumentSnapshot
                              ),
                            ),
                          );
                        },
                      );
                    }
                ),
              ), // <-- Missing closing parenthesis was here
            ],
          );
        }, // <-- Missing closing parenthesis was here
      ), // <-- Missing closing parenthesis was here
    ); // <-- Missing closing parenthesis was here
  } // <-- Missing closing bracket was here
} // <-- Missing closing bracket was here