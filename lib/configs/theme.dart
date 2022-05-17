import 'package:event/event.dart';
import 'package:flutter/material.dart';

import '../basic/commons.dart';
import '../basic/methods.dart';

final _lightTheme = ThemeData.light().copyWith(
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
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.black.withAlpha(120),
  ),
);

final _darkTheme = ThemeData.dark().copyWith(
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
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey.shade300,
    backgroundColor: Colors.grey.shade900,
  ),
);

ThemeData get lightTheme => theme != "2" ? _lightTheme : _darkTheme;

ThemeData get darkTheme => theme != "1" ? _darkTheme : _lightTheme;

const _propertyName = "theme";
late String theme = "0";

Map<String, String> _nameMap = {
  "0": "自动 (如果设备支持)",
  "1": "保持亮色",
  "2": "保持暗色",
};

Future initTheme() async {
  theme = await methods.loadProperty(_propertyName);
  if (theme == "") {
    theme = "0";
  }
}

String themeName() {
  return _nameMap[theme] ?? "-";
}

Future chooseTheme(BuildContext context) async {
  String? choose = await chooseMapDialog(context,
      title: "选择自动清理时间",
      values: _nameMap.map((key, value) => MapEntry(value, key)));
  if (choose != null) {
    await methods.saveProperty(_propertyName, choose);
    theme = choose;
    themeEvent.broadcast();
  }
}

final themeEvent = Event();

Widget themeSetting(BuildContext context) {
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return ListTile(
        onTap: () async {
          await chooseTheme(context);
          setState(() => {});
        },
        title: const Text("主题"),
        subtitle: Text(_nameMap[theme] ?? ""),
      );
    },
  );
}
