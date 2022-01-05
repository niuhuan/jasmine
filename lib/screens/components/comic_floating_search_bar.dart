import 'package:flutter/material.dart';

import '../comic_search_screen.dart';
import 'floating_search_bar.dart';

class ComicFloatingSearchBarScreen extends StatefulWidget {
  final FloatingSearchBarController controller;
  final Widget child;
  final ValueChanged<String>? onQuery;

  const ComicFloatingSearchBarScreen({
    Key? key,
    required this.controller,
    required this.child,
    this.onQuery,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ComicFloatingSearchBarScreenState();
}

class _ComicFloatingSearchBarScreenState
    extends State<ComicFloatingSearchBarScreen> {
  @override
  Widget build(BuildContext context) {
    return FloatingSearchBarScreen(
      controller: widget.controller,
      child: widget.child,
      onSubmitted: _onSubmitted,
    );
  }

  void _onSubmitted(String value) {
    widget.controller.hide();
    if (value.isNotEmpty && widget.onQuery != null) {
      widget.onQuery!(value);
    }
  }
}
