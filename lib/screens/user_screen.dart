import 'package:flutter/material.dart';
import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/configs/versions.dart';

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
        onTap: (){
          openUrl("https://github.com/niuhuan/jasmine/releases/");
        },
        child: Center(
          child: Text(
            latestVersion == null ? "没有检测到新版本" : "检测到新版本 : $latestVersion",
          ),
        ),
      ),
    );
  }
}
