import 'package:flutter/material.dart';
import 'package:jasmine/basic/entities.dart';
import 'package:jasmine/configs/pager_view_mode.dart';
import 'package:jasmine/screens/comic_info_screen.dart';

import 'comic_cover_card.dart';
import 'comic_info_card.dart';

class ComicList extends StatefulWidget {
  final bool inScroll;
  final List<ComicBasic> data;
  final Widget? append;
  final ScrollController? controller;

  const ComicList({
    Key? key,
    required this.data,
    this.append,
    this.controller,
    this.inScroll = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComicListState();
}

class _ComicListState extends State<ComicList> {
  @override
  void initState() {
    currentPagerViewModeEvent.subscribe(_setState);
    super.initState();
  }

  @override
  void dispose() {
    currentPagerViewModeEvent.unsubscribe(_setState);
    super.dispose();
  }

  _setState(_) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (currentPagerViewMode) {
      case PagerViewMode.cover:
        return _buildCoverMode();
      case PagerViewMode.info:
        return _buildInfoMode();
    }
  }

  Widget _buildCoverMode() {
    List<Widget> widgets = [];
    for (var i = 0; i < widget.data.length; i++) {
      widgets.add(GestureDetector(
        onTap: () {
          _pushToComicInfo(widget.data[i]);
        },
        child: ComicCoverCard(widget.data[i]),
      ));
    }
    if (widget.append != null) {
      widgets.add(widget.append!);
    }
    if (widget.inScroll) {
      final mq = MediaQuery.of(context);
      final width = (mq.size.width - 20) / 4;
      final height = width * 4 / 3;
      return Wrap(
        children: widgets.map((e) => SizedBox(
          width: width,
          height: height,
          child: e,
        )).toList(),
      );
    }
    return GridView.count(
      controller: widget.controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10.0),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      crossAxisCount: 4,
      childAspectRatio: 3 / 4,
      children: widgets,
    );
  }

  Widget _buildInfoMode() {
    List<Widget> widgets = [];
    for (var i = 0; i < widget.data.length; i++) {
      widgets.add(GestureDetector(
        onTap: () {
          _pushToComicInfo(widget.data[i]);
        },
        child: ComicInfoCard(widget.data[i]),
      ));
    }
    if (widget.append != null) {
      widgets.add(SizedBox(height: 100, child: widget.append!));
    }
    if (widget.inScroll) {
      return Column(children: widgets);
    }
    return ListView(
      controller: widget.controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      children: widgets,
    );
  }

  void _pushToComicInfo(ComicBasic data) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ComicInfoScreen(data);
    }));
  }
}
