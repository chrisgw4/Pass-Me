import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/user_page.dart';


class MyConnection extends StatefulWidget {

  late String user_identifier = "";

  MyConnection(String user_id, {super.key}) {
      user_identifier = user_id;
  }

  @override
  State<MyConnection> createState() => _MyConnectionState(user_identifier);
}

class _MyConnectionState extends State<MyConnection> {

  String user_identifier = "";
  User? currentUser = FirebaseAuth.instance.currentUser;

  _MyConnectionState(String user_id) {
    user_identifier = user_id;
  }


  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance.collection("User").doc(user_identifier).get();
  }





  @override
  Widget build(BuildContext context) {
    var snapshot = FirebaseFirestore.instance.collection("User").doc(user_identifier);

    // Use a stream builder so it will update live when a user updates profile
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("User").doc(user_identifier).snapshots(),
        builder: (context, snapshot) {

          //error
          if(snapshot.hasError) {
            // Note: displayMessageToUser might need 'await' if it returns a Future
            return const Center(child: Text("Error loading users."));
          }

          //loading
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.data == null) {
            return const Center(child: Text("No Users Found"));
          }

          // get all user
          final user_data = snapshot.data!.data();
          DocumentSnapshot user_future ;

          if (user_data != null)
            {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  FutureBuilder(
                      future: FirebaseFirestore.instance.collection("User").doc(user_identifier).get(),
                      builder: (context, snapshot) {

                        return GestureDetector(
                          child: CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(user_data["pfpimage"]),

                          ),
                          onTap: () {
                            // Navigate to the new page and pass the DocumentSnapshot
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserPage(
                                  userSnapshot: snapshot.data!,
                                ),
                              ),
                            );
                          },
                        );
                      }
                  ),



                  SizedBox(width: 10,),

                  Expanded(//color: Colors.red.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(snapshot.data?["username"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          softWrap: true,
                        ),

                        Text("" + snapshot.data?["greeting"],
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        
                      ],
                    ),
                  ),
                ],
              );
            }
          
          return Text("nothing to see here");
        }
    );
  }
}



