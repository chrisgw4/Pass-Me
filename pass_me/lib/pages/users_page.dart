import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pass_me/helper/helped_functions.dart';

import '../components/my_back_button.dart';


class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("User").snapshots(),
        builder: (context, snapshot) {
          //error
          if(snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          //loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.data == null) {
            return const Text("No Data");
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
                  padding: EdgeInsets.all(0),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    //indiv user get
                    final user = users[index];

                    return ListTile(
                      title: Text(user['username']),
                      subtitle: Text(user['email']),
                    );
                  }
                ),
              )

            ],
          );
        }
      )
    );
  }
}
