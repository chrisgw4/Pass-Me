import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pass_me/auth/auth.dart';
import 'package:pass_me/auth/login_or_register.dart';
import 'package:pass_me/firebase_options.dart';
import 'package:pass_me/pages/home_page.dart';
import 'package:pass_me/pages/profile_page.dart';
import 'package:pass_me/pages/register_page.dart';
import 'package:pass_me/pages/users_page.dart';
import 'package:pass_me/theme/dark_mode.dart';
import 'package:pass_me/theme/light_mode.dart';
import 'pages/login_page.dart';
import 'dart:math';
import 'dart:typed_data';

import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  


  // location permission
  await Permission.location.isGranted;       // Check Permission
  await Permission.location.request();       // Ask

  // Check Location Status
  await Permission.location.serviceStatus.isEnabled;

  // location enable dialog
  await Location.instance.requestService();

  // external storage permission
  await Permission.storage.isGranted;       // Check Permission
  await Permission.storage.request();          // Ask


  // Bluetooth permissions
  bool granted = !(await Future.wait([        // Check Permissions
    Permission.bluetooth.isGranted,
    Permission.bluetoothAdvertise.isGranted,
    Permission.bluetoothConnect.isGranted,
    Permission.bluetoothScan.isGranted,
  ])).any((element) => false);
  [                                           // Ask Permissions
    Permission.bluetooth,
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.bluetoothScan
  ].request();

  // Check Bluetooth Status
  await Permission.bluetooth.serviceStatus.isEnabled;

  // Android 12+
  await Permission.nearbyWifiDevices.request();

  const String userName = "AdvertiserName";
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
      serviceId: "com.yourdomain.appname", // IMPORTANT: Must be unique to your app
    );
    print("Advertising started successfully: $success");
  } catch (exception) {
    // Handle platform exceptions (e.g., Bluetooth disabled, permissions still denied)
    print("Error starting advertising: $exception");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: light_mode,
      darkTheme: dark_mode,
      routes: {
        '/login_register_page':(context) => LoginOrRegister(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/users_page': (context) => UsersPage()
      },
    );
  }
}
