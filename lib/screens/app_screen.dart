import 'package:flutter/material.dart';
import 'package:jasmine/screens/browser_screen.dart';
import 'package:jasmine/screens/user_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen>  {
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
    return Scaffold(
      body: PageView(
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
                  icon: Icon(e.icon),
                  activeIcon: Icon(e.activeIcon),
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
    );
  }
}

const List<AppScreenData> _screens = [
  AppScreenData(
    BrowserScreen(),
    '浏览',
    Icons.menu_book_outlined,
    Icons.menu_book,
  ),
  AppScreenData(
    UserScreen(),
    '书架',
    Icons.image_outlined,
    Icons.image,
  ),
];

class AppScreenData {
  final Widget screen;
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const AppScreenData(this.screen, this.title, this.icon, this.activeIcon);
}
