import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/screens/init_screen.dart';

void main() {
  runApp(const Jasmine());
}

class Jasmine extends StatelessWidget {
  const Jasmine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InitScreen(),
    );
  }
}
