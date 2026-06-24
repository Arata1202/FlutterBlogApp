import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/platform/index.dart';

class AppPageScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final List<Widget> materialActions;
  final Widget? cupertinoTrailing;

  const AppPageScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.materialActions = const [],
    this.cupertinoTrailing,
  });

  @override
  Widget build(BuildContext context) {
    if (AppPlatform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.white,
          middle: Image.asset('assets/title.webp', height: 28),
          leading: showBackButton ? const _CupertinoBackButton() : null,
          trailing: cupertinoTrailing,
        ),
        child: child,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/title.webp', height: 28),
        centerTitle: true,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: materialActions,
      ),
      body: child,
    );
  }
}

class _CupertinoBackButton extends StatelessWidget {
  const _CupertinoBackButton();

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.of(context).pop(),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
          SizedBox(width: 4),
          Text(
            '戻る',
            style: TextStyle(color: CupertinoColors.activeBlue),
          ),
        ],
      ),
    );
  }
}
