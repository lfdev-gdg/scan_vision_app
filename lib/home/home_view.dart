import 'package:flutter/material.dart';
import 'package:scan_vision_app/core/common/routes.dart';
import 'package:scan_vision_app/home/widgets/favoritos_tab.dart';
import 'package:scan_vision_app/home/widgets/home_tab.dart';
import 'package:scan_vision_app/models/livro_model.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _bottomNavigatorCurrentIndex = 0;
  var _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Vision App'),
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) {
          switch (index) {
            case 1:
              return FavoritosTab();
            default:
              return HomeTab();
          }
        },
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _bottomNavigatorCurrentIndex = index;
          });
        },
      ),
      //drawer: Drawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavigatorCurrentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Favoritos'),
          ),
        ],
        onTap: _bottomNavigationTap,
      ),
      floatingActionButton: _bottomNavigatorCurrentIndex == 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.pushNamed(
                context,
                Routes.cadastroLivro,
                arguments: Livro(),
              ),
            )
          : null,
    );
  }

  void _bottomNavigationTap(int index) {
    setState(() {
      _bottomNavigatorCurrentIndex = index;
    });

    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }
}
