import 'package:flutter/material.dart';
import 'package:hi_news/helpers/navigation_utils.dart';
import 'package:hi_news/resources/my_flutter_icons.dart';
import 'package:hi_news/screens/about/about_screen.dart';
import 'package:hi_news/screens/network_news/network_news_list_screen.dart';
import 'package:hi_news/screens/saved_news/saved_news_list_screen.dart';
import 'package:hi_news/screens/search/search_screen.dart';
import '../../resources/strings.dart';


class HomeScreen extends StatefulWidget {

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  var pageKeys = [
    Strings.search,
    Strings.news,
    Strings.authors,
    Strings.aboutUs
  ];
  
  var _currentPage;

  HomeScreenState() {
    _currentPage = pageKeys[0];
  }

  List pages = [
    SearchScreen(),
    NetworkNewsListScreen(),
    SavedNewsListScreen(),
    AboutScreen(),
  ];

  Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    Strings.search: GlobalKey<NavigatorState>(),
    Strings.news: GlobalKey<NavigatorState>(),
    Strings.authors: GlobalKey<NavigatorState>(),
    Strings.aboutUs: GlobalKey<NavigatorState>()
  };

  var _selectedIndex = 0;

  void selectTab(int tabItemIndex, int index) {
    final tabItem = pageKeys[tabItemIndex];
    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  void selectScreen(index, screen) {
    setState(() {
      pages[index] = screen;
    });
  }

  void updateSavedNews() {
    setState(() {
      pages[2] = new SavedNewsListScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Stack(
            children: [
              _buildNavigator(0),
              _buildNavigator(1),
              _buildNavigator(2),
              _buildNavigator(3)
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            onTap: (int index) {
              selectTab(index, index);
            },
            items: buildTopDestinations(),
            type: BottomNavigationBarType.fixed,
          ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    var currState = _navigatorKeys[_currentPage].currentState;
    final isFirstRouteInCurrentTab = !await currState.maybePop();
    if (isFirstRouteInCurrentTab) {
      if (_currentPage != pageKeys[0]) {
        selectTab(0, 1);
        return false;
      }
    }
    return isFirstRouteInCurrentTab;
  }

  Widget _buildNavigator(int index) {
    var pageKey = pageKeys[index];
    return Offstage(
      offstage: _currentPage != pageKey,
      child: Navigator(
        key: _navigatorKeys[pageKey],
        onGenerateRoute: (routeSettings) {
          return NavigationUtils.createRoute(pages[index]);
        },
      )
    );
  }

  List<BottomNavigationBarItem> buildTopDestinations() {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: Strings.search
      ),
      BottomNavigationBarItem(
        label: Strings.network,
        icon: Icon(MyFlutterIcons.earth),
      ),
      BottomNavigationBarItem(
        label: Strings.saved,
        icon: Icon(MyFlutterIcons.tags),
      ),
      BottomNavigationBarItem(
        label: Strings.aboutUs,
        icon: Icon(Icons.people, size: 28,),
      ),
    ];
  }

}
