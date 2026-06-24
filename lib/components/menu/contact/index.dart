import 'package:flutter/widgets.dart';

import '../../../config/app_urls.dart';
import '../web_page/index.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuWebPage(initialUrl: AppUrls.contact);
  }
}
