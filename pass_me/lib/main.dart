import 'package:flutter/material.dart';
import 'package:pass_me/theme/dark_mode.dart';
import 'package:pass_me/theme/light_mode.dart';
import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: light_mode,
      darkTheme: dark_mode,
    );
  }
}
