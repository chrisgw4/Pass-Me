import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../components/my_drawer.dart';


import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  bool _is_advertising = false;
  bool _is_discovering = false;

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


  Future<void> startSearchingForPasses() async {
    if (_is_advertising) {
      Nearby().stopAdvertising();
      _is_advertising = false;
    }

    if (_is_discovering) {
      Nearby().stopDiscovery();
      _is_discovering = false;
    }
    User? currentUser = FirebaseAuth.instance.currentUser;

    late String userName = "Default Name";
    if (currentUser?.email != null)
      {
        userName = currentUser!.email.toString();
      }

    const Strategy strategy = Strategy.P2P_CLUSTER;

    try {
      bool success = await Nearby().startAdvertising(
        userName,
        strategy,
        onConnectionInitiated: (String id, ConnectionInfo info) {
          // Called whenever a discoverer requests connection
          print("Connection initiated by: $id");
        },
        onConnectionResult: (String id, Status status) {
          // Called when connection is accepted/rejected
          print("Connection result for $id: $status");


        },
        onDisconnected: (String id) {
          // Callled whenever a discoverer disconnects from advertiser
          print("Disconnected from: $id");
        },
        serviceId: "com.example.pass_me", // IMPORTANT: Must be unique to your app
      );
      if (success) {
        _is_advertising = true;
      }
      print("Advertising started successfully: $success");
    } catch (exception) {
      // Handle platform exceptions (e.g., Bluetooth disabled, permissions still denied)
      print("Error starting advertising: $exception");
    }



    try {
      bool success = await Nearby().startDiscovery(
        userName,
        strategy, // https://developers.google.com/nearby/connections/strategies


        onEndpointFound: (String id,String userName, String serviceId) async {
          print("Caught Someone");
          // called when an advertiser is found
          print(userName.toString());
          if(currentUser != null ) {
            var user = FirebaseFirestore.instance.collection("User").doc(currentUser!.email.toString());
            var collection = user.collection("Connections");

            collection.doc(userName).set({
              "answer": "I am happy!",
            });

            // await FirebaseFirestore.instance
            //     .collection(
            //     "/User" + "/" + currentUser!.email.toString())
            //     .doc(userName)
            //     .set({
            //   'email': userName,
            //   'answer': "I love you!",
            // });
            // print(FirebaseFirestore.instance.collection("User/" + currentUser!.email.toString()).doc(userName));
          }

          // to be called by discover whenever an endpoint is found
          // callbacks are similar to those in startAdvertising method


        },
        onEndpointLost: (String? id) {
          print("Lost someone");
          //called when an advertiser is lost (only if we weren't connected to it )
        },
        serviceId: "com.example.pass_me", // uniquely identifies your app
      );
      if (success) {
        _is_discovering = true;
      }
    } catch (e) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
    }


  }


  @override
  Widget build(BuildContext context) {
    startSearchingForPasses();
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
                              const Divider(
                                height: 160,
                                thickness: 2,
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