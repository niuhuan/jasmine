import 'package:flutter/material.dart';
import 'package:jasmine/screens/init_screen.dart';

import 'basic/methods.dart';
import 'basic/navigatior.dart';

void main() async {
  runApp(const Jasmine());
}

class Jasmine extends StatelessWidget {
  const Jasmine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        ),
        dividerColor: Colors.grey.shade200,
        textSelectionTheme: const TextSelectionThemeData().copyWith(
          cursorColor: Colors.pink.shade200,
          selectionColor: Colors.pink.shade300.withAlpha(150),
          selectionHandleColor: Colors.pink.shade300.withAlpha(200),
        ),
        colorScheme: const ColorScheme.light().copyWith(
          secondary: Colors.pink.shade200,
        ),
      ),
      navigatorObservers: [routeObserver],
      home: const InitScreen(),
    );
  }
}
