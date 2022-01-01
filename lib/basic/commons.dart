import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

/// 显示一个toast
void defaultToast(BuildContext context, String title) {
  showToast(
    title,
    context: context,
    position: StyledToastPosition.center,
    animation: StyledToastAnimation.scale,
    reverseAnimation: StyledToastAnimation.fade,
    duration: const Duration(seconds: 4),
    animDuration: const Duration(seconds: 1),
    curve: Curves.elasticOut,
    reverseCurve: Curves.linear,
  );
}

Future<T?> chooseListDialog<T>(BuildContext context,
    {required List<T> items, required String title, String? tips}) async {
  List<Widget> widgets = [];
  if (tips != null) {
    widgets.add(Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Text(tips),
    ));
  }
  widgets.addAll(items.map((e) => SimpleDialogOption(
        onPressed: () {
          Navigator.of(context).pop(e);
        },
        child: Text('$e'),
      )));

  return showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(title),
        children: widgets,
      );
    },
  );
}

Future<T?> chooseMapDialog<T>(
  BuildContext buildContext, {
  required String title,
  required Map<String, T> values,
}) async {
  return await showDialog<T>(
    context: buildContext,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(title),
        children: values.entries
            .map((e) => SimpleDialogOption(
                  child: Text(e.key),
                  onPressed: () {
                    Navigator.of(context).pop(e.value);
                  },
                ))
            .toList(),
      );
    },
  );
}

Future saveImageFileToGallery(BuildContext context, String path) async {
  if (Platform.isAndroid) {
    if (!(await Permission.storage.request()).isGranted) {
      return;
    }
  }
  if (Platform.isIOS || Platform.isAndroid) {
    await methods.saveImageFileToGallery(path);
    defaultToast(context, "保存成功");
    return;
  }
  defaultToast(context, "暂不支持该平台");
}

Future<SortBy?> chooseSortBy(BuildContext context) async {
  return await chooseListDialog(context, title: "请选择排序方式", items: sorts);
}
