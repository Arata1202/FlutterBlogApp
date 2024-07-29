import 'package:flutter/material.dart';

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
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: '検索'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'メニュー'),
      ],
      currentIndex: currentIndex,
      elevation: 4,
      backgroundColor: Colors.white,
      onTap: onTap,
      selectedItemColor: Colors.blue,
    );
  }
}
