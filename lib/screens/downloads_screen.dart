import 'package:flutter/material.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/screens/components/content_builder.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late Future<List<DownloadAlbum>> _downloadsFuture;

  @override
  void initState() {
    _downloadsFuture = methods.allDownloads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("下载列表"),
      ),
      body: ContentBuilder(
        future: _downloadsFuture,
        onRefresh: () async {
          setState(() {
            _downloadsFuture = methods.allDownloads();
          });
        },
        successBuilder: (
          BuildContext context,
          AsyncSnapshot<List<DownloadAlbum>> snapshot,
        ) {
          return ListView();
        },
      ),
    );
  }
}
