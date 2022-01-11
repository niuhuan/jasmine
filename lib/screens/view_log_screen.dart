import 'package:flutter/material.dart';
import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/screens/components/floating_search_bar.dart';

import 'components/browser_bottom_sheet.dart';
import 'components/comic_floating_search_bar.dart';
import 'components/comic_pager.dart';
import 'components/actions.dart';

class ViewLogScreen extends StatefulWidget {
  const ViewLogScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ViewLogScreenState();
}

class _ViewLogScreenState extends State<ViewLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("浏览记录"),
        actions: [
          IconButton(
            onPressed: () async {
              String? choose = await chooseListDialog(
                context,
                items: ["是", "否"],
                title: "清除所有历史记录?",
              );
              if ("是" == choose) {
                await methods.clearViewLog();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const ViewLogScreen();
                  },
                ));
              }
            },
            icon: const Icon(Icons.auto_delete),
          ),
          const BrowserBottomSheetAction(),
        ],
      ),
      body: ComicPager(
        key: const Key("HISTORY"),
        onPage: (int page) async {
          final response = await methods.pageViewLog(page);
          return InnerComicPage(
            total: response.total,
            list: response.content,
          );
        },
      ),
    );
  }
}
