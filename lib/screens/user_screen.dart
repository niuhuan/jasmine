
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget{
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>_UserScreenState();
}

class _UserScreenState extends State<UserScreen>     with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    throw UnimplementedError();
  }
}