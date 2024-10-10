import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';

late String _cdnHost;

String _cdnHostName(String value) {
  return value == "0" ? "随机" : "分流$value";
}

String get currentCdnHostName => _cdnHostName(_cdnHost);

Future<void> initCdnHost() async {
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
        subtitle: Text(_cdnHostName(_cdnHost)),
      );
    },
  );
}


var cdnHosts = {
  "随机": "0",
  "分流1": "1",
  "分流2": "2",
  "分流3": "3",
  "分流4": "4",
  "分流5": "5",
  "分流6": "6",
  "分流7": "7",
};

Future<T?> chooseCdnDialog<T>(BuildContext buildContext) async {
  return await showDialog<T>(
    context: buildContext,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text("图片分流"),
        children: cdnHosts.entries
            .map(
              (e) => SimpleDialogOption(
            child: CdnOptionRow(
              e.key,
              e.value,
              key: Key("CDN:${e.value}"),
            ),
            onPressed: () {
              Navigator.of(context).pop(e.value);
            },
          ),
        )
            .toList(),
      );
    },
  );
}

class CdnOptionRow extends StatefulWidget {
  final String title;
  final String value;

  const CdnOptionRow(this.title, this.value, {Key? key}) : super(key: key);

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
        Text(widget.title),
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

