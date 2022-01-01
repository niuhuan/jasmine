import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/screens/components/comic_pager.dart';
import 'package:jasmine/screens/components/content_builder.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<CategoriesResponse> _future;
  String _slug = "";
  SortBy _sortBy = sortByDefault;

  @override
  void initState() {
    _future = methods.categories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ContentBuilder(
        future: _future,
        onRefresh: () async {
          setState(() {
            _future = methods.categories();
          });
        },
        successBuilder:
            (BuildContext context, AsyncSnapshot<CategoriesResponse> snapshot) {
          final categories = snapshot.requireData.categories;
          return Scaffold(
            appBar: AppBar(
              title: const Text("浏览"),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
              ],
            ),
            body: Column(children: [
              SizedBox(
                height: 56,
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  color: Color.alphaBlend(
                    Colors.grey.shade500.withOpacity(.05),
                    Theme.of(context).appBarTheme.backgroundColor ??
                        Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _MTabBar(
                          categories,
                          (index) {
                            setState(() {
                              _slug = categories[index].slug;
                            });
                          },
                        ),
                      ),
                      _buildOrderSwitch(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ComicPager(
                  key: Key("$_slug:$_sortBy"),
                  onPage: (int page) async {
                    final response = await methods.comics(_slug, _sortBy, page);
                    return response;
                  },
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildOrderSwitch() {
    final iconColor = Theme.of(context).appBarTheme.iconTheme?.color;
    return MaterialButton(
      onPressed: () async {
        final target = await chooseSortBy(context);
        if (target != null) {
          setState(() {
            _sortBy = target;
          });
        }
      },
      child: Column(
        children: [
          Expanded(child: Container()),
          Icon(
            Icons.sort,
            color: iconColor,
          ),
          Expanded(child: Container()),
          Text(_sortBy.toString(), style: TextStyle(color: iconColor)),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

class _MTabBar extends StatefulWidget {
  final List<Categories> categories;
  final void Function(int index) onTab;

  const _MTabBar(this.categories, this.onTab);

  @override
  State<StatefulWidget> createState() => _MTabBarState();
}

class _MTabBarState extends State<_MTabBar>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: widget.categories.length, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TabBar(
          onTap: widget.onTab,
          controller: _tabController,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.tab,
          padding: const EdgeInsets.only(left: 10, right: 10),
          indicator: BoxDecoration(
            color: Colors.grey.shade500.withOpacity(.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          tabs: widget.categories
              .map((e) => Tab(
                    text: e.name,
                  ))
              .toList()),
    );
  }
}
