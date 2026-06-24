import 'package:flutter/widgets.dart';

import '../../../config/app_urls.dart';
import '../web_page/index.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuWebPage(initialUrl: AppUrls.profile);
  }
}
