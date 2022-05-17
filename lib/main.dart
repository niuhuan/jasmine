import 'package:flutter/material.dart';
import 'package:jasmine/screens/components/mouse_and_touch_scroll_behavior.dart';
import 'package:jasmine/screens/init_screen.dart';

import 'basic/navigator.dart';
import 'configs/theme.dart';

void main() async {
  runApp(const Jasmine());
}

class Jasmine extends StatefulWidget {
  const Jasmine({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _JasmineState();
}

class _JasmineState extends State<Jasmine> {

  @override
  void initState() {
    themeEvent.subscribe(_setState);
    super.initState();
  }

  @override
  void dispose() {
    themeEvent.unsubscribe(_setState);
    super.dispose();
  }

  _setState(_) {
    setState(() => {});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: mouseAndTouchScrollBehavior,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      navigatorObservers: [routeObserver],
      home: const InitScreen(),
    );
  }
}
