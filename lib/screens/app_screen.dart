import 'package:flutter/material.dart';
import 'package:jasmine/screens/browser_screen.dart';
import 'package:jasmine/screens/comic_search_screen.dart';
import 'package:jasmine/screens/components/badge.dart';
import 'package:jasmine/screens/components/floating_search_bar.dart';
import 'package:jasmine/screens/user_screen.dart';

import 'components/comic_floating_search_bar.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _searchBarController = FloatingSearchBarController();

  late final List<AppScreenData> _screens = [
    AppScreenData(
      BrowserScreen(searchBarController: _searchBarController),
      '浏览',
      const Icon(Icons.menu_book_outlined),
      const Icon(Icons.menu_book),
    ),
    const AppScreenData(
      UserScreen(),
      '书架',
      VersionBadged(child: Icon(Icons.image_outlined)),
      VersionBadged(child: Icon(Icons.image)),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  var _selectedIndex = 0;
  late final _pageController = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(
      index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ComicFloatingSearchBarScreen(
      onQuery: (value) {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return ComicSearchScreen(initKeywords: value);
        }));
      },
      controller: _searchBarController,
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          allowImplicitScrolling: false,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: _screens.map((e) => e.screen).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _screens
              .map((e) => BottomNavigationBarItem(
                    label: e.title,
                    icon: e.icon,
                    activeIcon: e.activeIcon,
                  ))
              .toList(),
          currentIndex: _selectedIndex,
          iconSize: 20,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withAlpha(120),
        ),
      ),
    );
  }
}

class AppScreenData {
  final Widget screen;
  final String title;
  final Widget icon;
  final Widget activeIcon;

  const AppScreenData(this.screen, this.title, this.icon, this.activeIcon);
}
