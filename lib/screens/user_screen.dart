import 'package:flutter/material.dart';
import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/configs/versions.dart';
import 'package:jasmine/screens/components/badge.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          openUrl("https://github.com/niuhuan/jasmine/releases/");
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              color: Colors.grey.shade50,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Center(
                child: VersionBadged(
                  child: Text(
                    latestVersion == null
                        ? "没有检测到新版本"
                        : "检测到新版本 : $latestVersion",
                  ),
                ),
              ),
            );
          },),
      ),
    );
  }
}
