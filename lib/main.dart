import 'package:flutter/material.dart';
import 'package:mayur_traders_frontend/screens/user_registration_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget!),
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
        ],
      ),
      theme: ThemeData(
        // Primary color of the app
        primarySwatch: Colors.blue,

        // AppBar theme
        appBarTheme: const AppBarTheme(
          color: Colors.blue, // Background color of the AppBar
          titleTextStyle: TextStyle(
            color: Colors.white, // Text color of the AppBar title
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // Color of the AppBar icons
          ),
        ),

        // Button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // TextField theme
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(), // Border style for TextField
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.blue), // Border color when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.blueAccent), // Border color when focused
          ),
          labelStyle: TextStyle(color: Colors.blue), // Label color
          hintStyle: TextStyle(color: Colors.blueGrey), // Hint text color
        ),
      ),
      home: UserRegistrationForm(),//LoginScreen(),
    );
  }
}
