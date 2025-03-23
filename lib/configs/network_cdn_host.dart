import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';

late String _cdnHost;


String get currentCdnHostName => _cdnHost;

const _base64List = [
  "Y2RuLW1zcC5qbWFwaXByb3h5My5uZXQ=",
  "Y2RuLW1zcDIuam1hcGlub2RldWR6bi5uZXQ=",
  "Y2RuLW1zcDIuam1hcGlwcm94eTEuY2M=",
  "Y2RuLW1zcDIuam1hcGlwcm94eTIuY2M=",
  "Y2RuLW1zcC5qbWFwaW5vZGV1ZHpuLm5ldA==",
  "Y2RuLW1zcC5qbWFwaXByb3h5MS5jYw==",
  "Y2RuLW1zcC5qbWFwaXByb3h5Mi5jYw==",
];

var _cdnList = [];

Future<void> initCdnHost() async {
  for (var i = 0; i < _base64List.length; i++) {
    _cdnList.add(utf8.decode(base64.decode(_base64List[i])));
  }
  _cdnHost = await methods.loadCdnHost();
}

Future chooseCdnHost(BuildContext context) async {
  final choose = await chooseCdnDialog(context);
  if (choose != null) {
    await methods.saveCdnHost(choose);
    _cdnHost = choose;
  }
}

Widget cdnHostSetting() {
  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return ListTile(
        onTap: () async {
          await chooseCdnHost(context);
          setState(() {});
        },
        title: const Text("图片分流"),
        subtitle: Text(_cdnHost),
      );
    },
  );
}

Future<T?> chooseCdnDialog<T>(BuildContext buildContext) async {
  return await showDialog<T>(
    context: buildContext,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text("图片分流"),
        children: [
          ..._cdnList
            .map(
              (e) => SimpleDialogOption(
            child: CdnOptionRow(
              e,
              key: Key("CDN:${e}"),
            ),
            onPressed: () {
              Navigator.of(context).pop(e);
            },
          ),
        ),
            SimpleDialogOption(
              child: const Text("手动输入"),
              onPressed: () async {
                Navigator.of(context).pop(await _manualInputApiHost(context));
              },
            ),
            SimpleDialogOption(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
        ],
      );
    },
  );
}

final TextEditingController _controller = TextEditingController();

Future<String> _manualInputApiHost(BuildContext context) async {
  _controller.text = _cdnHost;
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("手动输入CDN地址"),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: "www.example.com",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("取消"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(_controller.text);
            },
            child: const Text("确定"),
          ),
        ],
      );
    },
  );
}

class CdnOptionRow extends StatefulWidget {
  final String value;

  const CdnOptionRow(this.value, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CdnOptionRowState();
}

class _CdnOptionRowState extends State<CdnOptionRow> {
  late Future<int> _feature;

  @override
  void initState() {
    super.initState();
    _feature = methods.pingCdn(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.value),
        Expanded(child: Container()),
        FutureBuilder(
          future: _feature,
          builder: (
              BuildContext context,
              AsyncSnapshot<int> snapshot,
              ) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const PingStatus(
                "测速中",
                Colors.blue,
              );
            }
            if (snapshot.hasError) {
              return const PingStatus(
                "失败",
                Colors.red,
              );
            }
            int ping = snapshot.requireData;
            if (ping <= 200) {
              return PingStatus(
                "${ping}ms",
                Colors.green,
              );
            }
            if (ping <= 500) {
              return PingStatus(
                "${ping}ms",
                Colors.yellow,
              );
            }
            return PingStatus(
              "${ping}ms",
              Colors.orange,
            );
          },
        ),
      ],
    );
  }
}

class PingStatus extends StatelessWidget {
  final String title;
  final Color color;

  const PingStatus(this.title, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '\u2022',
          style: TextStyle(
            color: color,
          ),
        ),
        Text(" $title"),
      ],
    );
  }
}

