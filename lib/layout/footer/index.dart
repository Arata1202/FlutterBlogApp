import 'package:flutter/cupertino.dart';

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
    return CupertinoTabBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.compass), label: 'ホーム'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.search), label: '検索'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2), label: 'メニュー'),
      ],
      currentIndex: currentIndex,
      backgroundColor: CupertinoColors.white,
      onTap: onTap,
      activeColor: CupertinoColors.activeBlue,
      inactiveColor: CupertinoColors.inactiveGray,
    );
  }
}
