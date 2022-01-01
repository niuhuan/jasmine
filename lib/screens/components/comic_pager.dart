import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/configs/pager_controller_mode.dart';

import '../comic_info_screen.dart';
import 'images.dart';

class ComicPager extends StatefulWidget {
  final Future<List<ComicSimple>> Function(int page) onPage;

  const ComicPager({required this.onPage, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComicPagerState();
}

class _ComicPagerState extends State<ComicPager> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _StreamPager(onPage: widget.onPage);
  }
}

class _StreamPager extends StatefulWidget {
  final Future<List<ComicSimple>> Function(int page) onPage;

  const _StreamPager({Key? key, required this.onPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StreamPagerState();
}

class _StreamPagerState extends State<_StreamPager> {
  bool _over = false;
  int _nextPage = 1;

  var _joining = false;
  var _joinSuccess = true;

  Future<List<ComicSimple>> _next() async {
    var response = await widget.onPage(_nextPage);
    _nextPage++;
    _over = response.isEmpty;
    return response;
  }

  Future _join() async {
    try {
      setState(() {
        _joining = true;
      });
      _data.addAll(await _next());
      setState(() {
        _joinSuccess = true;
        _joining = false;
      });
    } catch (_) {
      setState(() {
        _joinSuccess = false;
        _joining = false;
      });
    }
  }

  final List<ComicSimple> _data = [];
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_onScroll);
    _join();
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_joining || _over) {
      return;
    }
    if (_controller.position.pixels + 100 <
        _controller.position.maxScrollExtent) {
      return;
    }
    _join();
  }

  Widget? _buildLoadingCard() {
    if (_joining) {
      return Card(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: const CupertinoActivityIndicator(
                radius: 14,
              ),
            ),
            const Text('加载中'),
          ],
        ),
      );
    }
    if (!_joinSuccess) {
      return Card(
        child: InkWell(
          onTap: () {
            _join();
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const Icon(Icons.sync_problem_rounded),
              ),
              const Text('出错, 点击重试'),
            ],
          ),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _PagerGirdView(
      controller: _controller,
      data: _data,
      append: _buildLoadingCard(),
    );
  }
}

class _PagerGirdView extends StatelessWidget {
  final List<ComicSimple> data;
  final Widget? append;
  final ScrollController? controller;

  const _PagerGirdView(
      {Key? key, required this.data, this.append, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var i = 0; i < data.length; i++) {
      widgets.add(_buildImageCard(context, data[i]));
    }
    if (append != null) {
      widgets.add(append!);
    }

    return GridView.count(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10.0),
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      crossAxisCount: 4,
      childAspectRatio: 3 / 4,
      children: widgets,
    );
  }

  Widget _buildImageCard(BuildContext context, ComicSimple item) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ComicInfoScreen(item);
          },
        ));
      },
      child: Card(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                JM3x4Cover(
                  comicId: item.id,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
