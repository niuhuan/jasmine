import 'package:flutter/material.dart';
import 'package:jasmine/basic/entities.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/basic/navigatior.dart';
import 'package:jasmine/screens/comic_search_screen.dart';
import 'package:jasmine/screens/components/comic_info_card.dart';
import 'package:jasmine/screens/components/comic_list.dart';
import 'package:jasmine/screens/components/item_builder.dart';

import 'comic_reader_screen.dart';
import 'components/comic_comments_list.dart';
import 'components/continue_read_button.dart';

class ComicInfoScreen extends StatefulWidget {
  final ComicBasic simple;

  const ComicInfoScreen(this.simple, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComicInfoScreenState();
}

class _ComicInfoScreenState extends State<ComicInfoScreen> with RouteAware {
  final _continueReadButtonController = ContinueReadButtonController();
  var _favouriteLoading = false;
  var _tabIndex = 0;
  late Future<AlbumResponse> _albumFuture = methods.album(widget.simple.id);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _continueReadButtonController.reload();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.simple.name),
        actions: [
          FutureBuilder(
            future: _albumFuture,
            builder: (
              BuildContext context,
              AsyncSnapshot<AlbumResponse> snapshot,
            ) {
              if (snapshot.hasError ||
                  snapshot.connectionState != ConnectionState.done) {
                return Container();
              }
              if (_favouriteLoading) {
                return IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.sync,
                  ),
                );
              }
              return IconButton(
                onPressed: () {
                  _changeFavourite(snapshot.requireData);
                },
                icon: Icon(
                  snapshot.requireData.isFavorite
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ComicInfoCard(widget.simple, link: true),
          ItemBuilder(
            future: _albumFuture,
            onRefresh: () async {
              setState(() {
                _albumFuture = methods.album(widget.simple.id);
              });
            },
            successBuilder: (
              BuildContext context,
              AsyncSnapshot<AlbumResponse> snapshot,
            ) {
              AlbumResponse album = snapshot.requireData;

              var _tabs = <Widget>[
                Tab(text: '章节 (${album.series.length})'),
                Tab(text: '评论 (${album.commentTotal})'),
                Tab(text: '推荐 (${album.relatedList.length})'),
              ];

              final _views = [
                _ComicSerials(
                  widget.simple,
                  album,
                  _continueReadButtonController,
                ),
                ComicCommentsList(mode: "manhua", aid: widget.simple.id),
                _ComicRelatedList(album.relatedList),
              ];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTags(album.tags),
                  const Divider(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: SelectableText(widget.simple.description),
                  ),
                  const Divider(),
                  DefaultTabController(
                    length: _tabs.length,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          color: theme.colorScheme.secondary.withOpacity(.025),
                          child: TabBar(
                            tabs: _tabs,
                            indicatorColor: theme.colorScheme.secondary,
                            labelColor: theme.colorScheme.secondary,
                            unselectedLabelColor:
                                theme.textTheme.bodyText1?.color,
                            onTap: (val) async {
                              setState(() {
                                _tabIndex = val;
                              });
                            },
                          ),
                        ),
                        _views[_tabIndex],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTags(List<String> tags) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: constraints.maxWidth,
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: tags.map((e) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return ComicSearchScreen(initKeywords: e);
                    }),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 3,
                    bottom: 3,
                  ),
                  margin: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                    top: 3,
                    bottom: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    border: Border.all(
                      style: BorderStyle.solid,
                      color: Colors.pink.shade400,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.pink.shade500,
                      height: 1.4,
                    ),
                    strutStyle: const StrutStyle(
                      height: 1.4,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future _changeFavourite(AlbumResponse data) async {
    setState(() {
      _favouriteLoading = true;
    });
    try {
      await methods.setFavorite(data.id);
      setState(() {
        data.isFavorite = !data.isFavorite;
      });
    } finally {
      setState(() {
        _favouriteLoading = false;
      });
    }
  }
}

class _ComicSerials extends StatefulWidget {
  final ComicBasic comicSimple;
  final AlbumResponse album;
  final ContinueReadButtonController continueReadButtonController;

  const _ComicSerials(this.comicSimple, this.album, this.continueReadButtonController);

  @override
  State<StatefulWidget> createState() => _ComicSerialsState();
}

class _ComicSerialsState extends State<_ComicSerials> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 20),
        ContinueReadButton(
          controller:  widget.continueReadButtonController,
          album: widget.album,
          onChoose: _onChoose,
        ),
        widget.album.series.isEmpty ? _buildOneButton() : _buildSeriesWrap(),
      ],
    );
  }

  Widget _buildOneButton() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: () {
                _push(
                  widget.comicSimple,
                  widget.album.series,
                  widget.comicSimple.id,
                  0,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Text("开始阅读"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesWrap() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.spaceAround,
        children: [
          ...widget.album.series.map((e) {
            return MaterialButton(
              onPressed: () {
                _push(widget.comicSimple, widget.album.series, e.id, 0);
              },
              color: Colors.white,
              child: Text(
                e.sort + (e.name == "" ? "" : (" - ${e.name}")),
                style: const TextStyle(color: Colors.black),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _push(
    ComicBasic comic,
    List<Series> series,
    int seriesId,
    int initRank,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComicReaderScreen(
          comic: comic,
          series: series,
          seriesId: seriesId,
          initRank: initRank,
        ),
      ),
    );
  }

  void _onChoose(int epOrder, int pictureRank) {
    _push(
      widget.comicSimple,
      widget.album.series,
      epOrder,
      pictureRank,
    );
  }
}

class _ComicRelatedList extends StatefulWidget {
  final List<ComicBasic> relatedList;

  const _ComicRelatedList(this.relatedList);

  @override
  State<StatefulWidget> createState() => _ComicRelatedListState();
}

class _ComicRelatedListState extends State<_ComicRelatedList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ComicList(data: widget.relatedList, inScroll: true);
  }
}
