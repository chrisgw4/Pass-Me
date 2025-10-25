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

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
