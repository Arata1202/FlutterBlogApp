import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../platform/index.dart';

Future<T?> pushAppPage<T>(BuildContext context, Widget page) {
  final route =
      AppPlatform.isIOS
          ? CupertinoPageRoute<T>(builder: (_) => page)
          : MaterialPageRoute<T>(builder: (_) => page);

  return Navigator.of(context).push(route);
}
