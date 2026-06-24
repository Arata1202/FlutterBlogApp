import 'package:flutter/widgets.dart';

import '../../../config/app_urls.dart';
import '../web_page/index.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuWebPage(initialUrl: AppUrls.privacy);
  }
}
