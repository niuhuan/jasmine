import 'package:flutter/material.dart';
import 'package:jasmine/basic/entities.dart';
import 'package:jasmine/basic/methods.dart';

// 继续阅读按钮
class ContinueReadButton extends StatefulWidget {
  final AlbumResponse album;
  final Function(int epOrder, int pictureRank) onChoose;
  final ContinueReadButtonController controller;

  const ContinueReadButton({
    Key? key,
    required this.album,
    required this.onChoose,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContinueReadButtonState();
}

class _ContinueReadButtonState extends State<ContinueReadButton> {
  late Future<ViewLog?> _viewFuture = methods.findViewLog(widget.album.id);

  void _reload() {
    setState(() {
      _viewFuture = methods.findViewLog(widget.album.id);
    });
  }

  @override
  void initState() {
    widget.controller._state = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var width = constraints.maxWidth;
        return FutureBuilder(
          future: _viewFuture,
          builder: (BuildContext context, AsyncSnapshot<ViewLog?> snapshot) {
            late void Function() onPressed;
            late String text;
            if (snapshot.connectionState != ConnectionState.done) {
              onPressed = () {};
              text = '加载中';
            } else {
              ViewLog? viewLog = snapshot.data;
              if (viewLog == null || viewLog.lastViewChapterId == 0) {
                if (widget.album.series.isEmpty) {
                  return Container();
                }
                onPressed = () {
                  if (widget.album.series.isEmpty) {
                    widget.onChoose(widget.album.id, 0);
                  } else {
                    widget.album.series
                        .sort((a, b) => a.sort.compareTo(b.sort));
                    widget.onChoose(widget.album.series[0].id, 0);
                  }
                };
                text = '从头开始';
              } else {
                onPressed = () {
                  widget.onChoose(
                    viewLog.lastViewChapterId,
                    viewLog.lastViewPage,
                  );
                };
                text = '继续阅读'; // todo names and pages
              }
            }
            return Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(bottom: 10),
              width: width,
              child: MaterialButton(
                onPressed: onPressed,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(.05),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ContinueReadButtonController {
  _ContinueReadButtonState? _state;

  reload() => _state?._reload();
}
