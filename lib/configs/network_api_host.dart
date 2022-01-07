import 'package:flutter/material.dart';
import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/basic/methods.dart';

const _apiHostMap = {
  "随机": "null",
  "原始": "\"www.asjmapihost.cc\"",
  "分流1": "\"www.jmapibranch1.cc\"",
  "分流2": "\"www.jmapibranch2.cc\"",
  "分流3": "\"www.jmapibranch3.cc\"",
};

late String _apiHost;

String _apiHostName(String value) {
  if (value == "") {
    value = "null";
  }
  return _apiHostMap.map((key, value) => MapEntry(value, key))[value] ?? "";
}

String get currentApiHostName => _apiHostName(_apiHost);

Future<void> initApiHost() async {
  _apiHost = await methods.loadApiHost();
}

Future chooseApiHost(BuildContext context) async {
  final choose = await chooseMapDialog(
    context,
    title: "API分流",
    values: _apiHostMap,
  );
  if (choose != null) {
    await methods.saveApiHost(choose);
    _apiHost = choose;
  }
}

Widget apiHostSetting() {
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return ListTile(
        onTap: () async {
          await chooseApiHost(context);
          setState(() {});
        },
        title: const Text("API分流"),
        subtitle: Text(_apiHostName(_apiHost)),
      );
    },
  );
}
