import 'package:flutter/material.dart';

import '../configs/android_display_mode.dart';
import '../configs/proxy.dart';
import '../configs/theme.dart';
import '../configs/using_right_click_pop.dart';
import 'components/right_click_pop.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return rightClickPop(child: buildScreen(context), context: context);
  }

  Widget buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置"),
      ),
      body: ListView(
        children: [
          const Divider(),
          proxySetting(),
          const Divider(),
          themeSetting(context),
          const Divider(),
          androidDisplayModeSetting(),
          const Divider(),
          usingRightClickPopSetting(),
          const Divider(),
        ],
      ),
    );
  }
}
