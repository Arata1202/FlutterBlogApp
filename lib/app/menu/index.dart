import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../components/menu/profile/index.dart';
import '../../components/menu/privacy/index.dart';
import '../../components/menu/sns/index.dart';
import '../../common/admob/banner/index.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/title.webp',
          height: 28,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
      ),
      body: Column(
        children: [
          BannerAdWidget(adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_MENU')),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  _menuItem("筆者について", const Icon(Icons.person), () {
                    _navigateTo(context, const Profile());
                  }),
                  _divider(),
                  _menuItem("筆者のSNS", const Icon(Icons.public), () {
                    _navigateTo(context, const Sns());
                  }),
                  _divider(),
                  _menuItem("アプリをシェア", const Icon(Icons.share), _shareApp),
                  _divider(),
                  _menuItem("プライバシーポリシー", const Icon(Icons.privacy_tip), () {
                    _navigateTo(context, const Privacy());
                  }),
                  _divider(),
                  _menuItem("お問い合わせ", const Icon(Icons.email), _launchMailApp),
                  _divider(),
                  _menuItem("プッシュ通知設定", const Icon(Icons.notifications),
                      _navigateToPushNotificationSettings),
                  _divider(),
                  _menuItem(
                      "レビューを送信", const Icon(Icons.rate_review), _requestReview),
                  _divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, Icon icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 4.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10.0),
              child: icon,
            ),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 15.0),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const Divider(
        color: Colors.grey,
        height: 1,
        thickness: 0.5,
      ),
    );
  }

  void _launchMailApp() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'realunivlog@gmail.com',
      query: 'subject=お問い合わせ&body=▼お問い合わせ内容を記入してください。',
    );

    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void _shareApp() {
    Share.share(
      'https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103',
      subject: 'リアル大学生',
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _navigateToPushNotificationSettings() async {
    const String url = 'app-settings:';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  void _requestReview() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {
      print('In-app review not available');
    }
  }
}
