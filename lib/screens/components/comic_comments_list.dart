import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/screens/components/item_builder.dart';

import 'avatar.dart';

class ComicCommentsList extends StatefulWidget {
  final String mode;
  final int aid;

  const ComicCommentsList({
    required this.mode,
    required this.aid,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComicCommentsListState();
}

class _ComicCommentsListState extends State<ComicCommentsList> {
  late Future<CommentPage> _future;
  int _maxPage = 1;
  int _page = 1;

  Future<CommentPage> _loadPage() async {
    final response = await methods.forum(widget.mode, widget.aid, _page);
    if (_page == 1) {
      if (response.total == 0) {
        _maxPage = 1;
      } else {
        _maxPage = (response.total / response.list.length).ceil();
      }
    }
    return response;
  }

  @override
  void initState() {
    _future = _loadPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ItemBuilder(
      future: _future,
      onRefresh: () async {
        setState(() {
          _future = _loadPage();
        });
      },
      successBuilder: (
        BuildContext context,
        AsyncSnapshot<CommentPage> snapshot,
      ) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrePage(),
            ...snapshot.requireData.list.map((e) => _buildComment(e)),
            _buildPostComment(),
            _buildNextPage(),
          ],
        );
      },
    );
  }

  Widget _buildComment(Comment comment) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => CommentScreen(
        //       widget.mainType,
        //       widget.mainId,
        //       comment,
        //     ),
        //   ),
        // );
      },
      child: _ComicCommentItem(
        mode: widget.mode,
        aid: widget.aid,
        comment: comment,
      ),
    );
  }

  Widget _buildPrePage() {
    if (_page > 1) {
      return InkWell(
        onTap: () {
          setState(() {
            _page--;
            _future = _loadPage();
          });
        },
        child: Container(
          padding: const EdgeInsets.all(30),
          child: const Center(
            child: Text('上一页'),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildNextPage() {
    if (_page < _maxPage) {
      return InkWell(
        onTap: () {
          setState(() {
            _page++;
            _future = _loadPage();
          });
        },
        child: Container(
          padding: const EdgeInsets.all(30),
          child: const Center(
            child: Text('下一页'),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildPostComment() {
    return InkWell(
      onTap: () async {
        // String? text = await inputString(context, '请输入评论内容');
        // if (text != null && text.isNotEmpty) {
        //   try {
        //     switch (widget.mainType) {
        //       case CommentMainType.COMIC:
        //         await method.postComment(widget.mainId, text);
        //         break;
        //       case CommentMainType.GAME:
        //         await method.postGameComment(widget.mainId, text);
        //         break;
        //     }
        //     setState(() {
        //       _future = _loadPage();
        //     });
        //   } catch (e) {
        //     defaultToast(context, "评论失败");
        //   }
        //   }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: .25,
              style: BorderStyle.solid,
              color: Colors.grey.shade500.withOpacity(.5),
            ),
            bottom: BorderSide(
              width: .25,
              style: BorderStyle.solid,
              color: Colors.grey.shade500.withOpacity(.5),
            ),
          ),
        ),
        padding: const EdgeInsets.all(30),
        child: const Center(
          child: Text('我有话要讲'),
        ),
      ),
    );
  }
}

class _ComicCommentItem extends StatefulWidget {
  // 清除缓存使用mode和aid
  final String mode;
  final int aid;
  final Comment comment;

  const _ComicCommentItem({
    required this.mode,
    required this.aid,
    required this.comment,
  });

  @override
  State<StatefulWidget> createState() => _ComicCommentItemState();
}

class _ComicCommentItemState extends State<_ComicCommentItem> {
  var likeLoading = false;

  @override
  Widget build(BuildContext context) {
    var comment = widget.comment;
    var theme = Theme.of(context);
    var nameStyle = const TextStyle(fontWeight: FontWeight.bold);
    var levelStyle = TextStyle(
        fontSize: 12, color: theme.colorScheme.secondary.withOpacity(.8));
    var connectStyle =
        TextStyle(color: theme.textTheme.bodyText1?.color?.withOpacity(.8));
    var datetimeStyle = TextStyle(
        color: theme.textTheme.bodyText1?.color?.withOpacity(.6), fontSize: 12);
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: .25,
            style: BorderStyle.solid,
            color: Colors.grey.shade500.withOpacity(.5),
          ),
          bottom: BorderSide(
            width: .25,
            style: BorderStyle.solid,
            color: Colors.grey.shade500.withOpacity(.5),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(comment.photo),
          Container(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text(comment.name, style: nameStyle),
                          Text(
                            comment.addtime,
                            style: datetimeStyle,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(height: 3),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Text("Lv. ? (?)", style: levelStyle),
                          Text.rich(TextSpan(
                            style: levelStyle,
                            children: [
                              comment.replys.isNotEmpty
                                  ? TextSpan(children: [
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(Icons.message,
                                            size: 13,
                                            color: theme.colorScheme.secondary
                                                .withOpacity(.7)),
                                      ),
                                      WidgetSpan(child: Container(width: 5)),
                                      TextSpan(
                                        text: '${comment.replys.length}',
                                      ),
                                    ])
                                  : const TextSpan(),
                              WidgetSpan(child: Container(width: 12)),
                              WidgetSpan(
                                  child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    likeLoading = true;
                                  });
                                  // try {
                                  //   switch (widget.mainType) {
                                  //     case CommentMainType.COMIC:
                                  //       await method.switchLikeComment(
                                  //         comment.id,
                                  //         widget.mainId,
                                  //       );
                                  //       break;
                                  //     case CommentMainType.GAME:
                                  //       await method.switchLikeGameComment(
                                  //         comment.id,
                                  //         widget.mainId,
                                  //       );
                                  //       break;
                                  //   }
                                  //   setState(() {
                                  //     if (comment.isLiked) {
                                  //       comment.isLiked = false;
                                  //       comment.likesCount--;
                                  //     } else {
                                  //       comment.isLiked = true;
                                  //       comment.likesCount++;
                                  //     }
                                  //   });
                                  // } catch (e, s) {
                                  //   defaultToast(context, "点赞失败");
                                  // } finally {
                                  //   setState(() {
                                  //     likeLoading = false;
                                  //   });
                                  // }
                                },
                                child: Text.rich(
                                  TextSpan(style: levelStyle, children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Icon(
                                        Icons.favorite,
                                        // likeLoading
                                        //     ? Icons.refresh
                                        //     : comment.isLiked
                                        //         ? Icons.favorite
                                        //         : Icons.favorite_border,
                                        size: 13,
                                        color: theme.colorScheme.secondary
                                            .withOpacity(.7),
                                      ),
                                    ),
                                    WidgetSpan(child: Container(width: 5)),
                                    TextSpan(
                                      text: '${comment.likes}',
                                    ),
                                  ]),
                                ),
                              )),
                            ],
                          )),
                        ],
                      ),
                    );
                  },
                ),
                Container(height: 5),
                Text(comment.content, style: connectStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
