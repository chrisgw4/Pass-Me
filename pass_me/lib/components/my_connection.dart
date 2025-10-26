import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



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
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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

            return Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(snapshot.data?["pfpimage"]),

                ),
                  SizedBox(width: 10,),
                  Text(snapshot.data?["username"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)


              ],

            );
            return Text(snapshot.data?["username"]);
          }
          return Text("Nothing found");
        }
        );
  }
}



