import 'package:flutter/widgets.dart';

import '../../../config/app_urls.dart';
import '../web_page/index.dart';

class Copyright extends StatelessWidget {
  const Copyright({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuWebPage(initialUrl: AppUrls.copyright);
  }
}
