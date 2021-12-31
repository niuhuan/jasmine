import 'dart:async';

import 'package:flutter/material.dart';

import 'app_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future _init() async {
    Future.delayed(Duration.zero, () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
        return const AppScreen();
      }));
    });
  }
}
