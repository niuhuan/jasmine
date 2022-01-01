import 'package:flutter/material.dart';
import 'package:jasmine/screens/init_screen.dart';

void main() {
  runApp(const Jasmine());
}

class Jasmine extends StatelessWidget {
  const Jasmine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme().copyWith(
            titleTextStyle: const TextStyle().copyWith(
              color: Colors.white,
            ),
            backgroundColor: Colors.black87,
            iconTheme: const IconThemeData().copyWith(
              color: Colors.white,
            ),
          ),
          tabBarTheme: const TabBarTheme().copyWith(
            labelColor: Colors.deepOrangeAccent,
            unselectedLabelColor: Colors.white,
          )),
      home: const InitScreen(),
    );
  }
}
