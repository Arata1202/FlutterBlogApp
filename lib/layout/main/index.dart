import 'package:flutter/material.dart';
import '../../app/search/index.dart';
import '../../app/menu/index.dart';
import '../../app/home/index.dart';
import '../../layout/footer/index.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // 横スクロールを禁止
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: const <Widget>[
          Home(),
          Search(),
          Menu(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
