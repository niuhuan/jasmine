import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/configs/configs.dart';

import 'app_screen.dart';
import 'network_setting_screen.dart';

bool _hadInit = false;

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
    return Scaffold(
      backgroundColor: const Color(0xff99dcd7),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Image.asset(
            "lib/assets/startup.webp",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future _init() async {
    try {
      if (!_hadInit) {
        await methods.init();
        _hadInit = true;
      }
      await initConfigs();
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return const AppScreen();
          }),
        );
      });
    } catch (e, st) {
      print("$e\n$st");
      defaultToast(context, "初始化失败, 请设置网络");
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) {
            return const NetworkSettingScreen();
          }),
        );
      });
    }
  }
}
