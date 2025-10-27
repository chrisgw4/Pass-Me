import "package:flutter/material.dart";

ThemeData dark_mode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade300,
      primary: Colors.grey.shade200,
      secondary: Colors.grey.shade400,
      tertiary: Colors.grey.shade600,
      inversePrimary: Colors.grey.shade800,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: Colors.grey[800],
      displayColor: Colors.black,
    )
);