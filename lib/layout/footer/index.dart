import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.compass), label: 'ホーム'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.search), label: '検索'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.square_grid_2x2), label: 'メニュー'),
        ],
        currentIndex: currentIndex,
        backgroundColor: CupertinoColors.white,
        onTap: onTap,
        activeColor: CupertinoColors.activeBlue,
        inactiveColor: CupertinoColors.inactiveGray,
      );
    } else {
      return BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '検索',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'メニュー',
          ),
        ],
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        onTap: onTap,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      );
    }
  }
}
