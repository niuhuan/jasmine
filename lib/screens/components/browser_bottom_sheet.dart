import 'package:jasmine/basic/commons.dart';
import 'package:jasmine/basic/methods.dart';
import 'package:jasmine/configs/network_api_host.dart';
import 'package:jasmine/configs/network_cdn_host.dart';
import 'package:jasmine/configs/pager_controller_mode.dart';
import 'package:jasmine/configs/pager_view_mode.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

class BrowserBottomSheetAction extends StatelessWidget {
  const BrowserBottomSheetAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        _displayBrowserBottomSheet(context);
      },
      icon: const Icon(Icons.menu),
    );
  }
}

Future _displayBrowserBottomSheet(BuildContext context) async {
  await showMaterialModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xAA000000),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * (.45),
        child: _BrowserBottomSheet(),
      );
    },
  );
}

class _BrowserBottomSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BrowserBottomSheetState();
}

class _BrowserBottomSheetState extends State<_BrowserBottomSheet> {
  @override
  void initState() {
    currentPagerControllerModeEvent.subscribe(_setState);
    currentPagerViewModeEvent.subscribe(_setState);
    super.initState();
  }

  @override
  void dispose() {
    currentPagerControllerModeEvent.unsubscribe(_setState);
    currentPagerViewModeEvent.unsubscribe(_setState);
    super.dispose();
  }

  _setState(_) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Expanded(child: Container()),
            _bottomIcon(
              icon: Icons.view_day_outlined,
              title: currentPagerControllerModeName,
              onPressed: () async {
                await choosePagerControllerMode(context);
                setState(() {});
              },
            ),
            Expanded(child: Container()),
            _bottomIcon(
              icon: Icons.view_quilt,
              title: currentPagerViewModeName,
              onPressed: () async {
                await choosePagerViewMode(context);
                setState(() {});
              },
            ),
            Expanded(child: Container()),
            _bottomIcon(
              icon: Icons.cleaning_services_rounded,
              title: "清理",
              onPressed: () async {
                defaultToast(context, "清理中");
                try {
                  await methods.cleanAllImageCache();
                  defaultToast(context, "清理成功");
                } catch (e) {
                  print("$e");
                  defaultToast(context, "清理失败");
                }
                setState(() {});
              },
            ),
            Expanded(child: Container()),
          ],
        ),
        Row(
          children: [
            Expanded(child: Container()),
            _bottomIcon(
              icon: Icons.shuffle,
              title: currentApiHostName,
              onPressed: () async {
                await chooseApiHost(context);
                setState(() {});
              },
            ),
            Expanded(child: Container()),
            _bottomIcon(
              icon: Icons.repeat_one,
              title: currentCdnHostName,
              onPressed: () async {
                await chooseCdnHost(context);
                setState(() {});
              },
            ),
            Expanded(child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _bottomIcon({
    required IconData icon,
    required String title,
    required void Function() onPressed,
  }) {
    return Expanded(
      child: Center(
        child: Column(
          children: [
            IconButton(
              iconSize: 55,
              icon: Column(
                children: [
                  Container(height: 3),
                  Icon(
                    icon,
                    size: 25,
                    color: Colors.white,
                  ),
                  Container(height: 3),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                  Container(height: 3),
                ],
              ),
              onPressed: onPressed,
            )
          ],
        ),
      ),
    );
  }
}
