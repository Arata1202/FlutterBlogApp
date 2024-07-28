import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double toolbarHeight;

  const CustomAppBar({Key? key, required this.toolbarHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: toolbarHeight,
      elevation: 4,
      title: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}
