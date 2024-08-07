import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../components/menu/profile/index.dart';
import '../../components/menu/privacy/index.dart';
import '../../components/menu/sns/index.dart';
import '../../components/menu/history/index.dart';
import '../../common/admob/banner/index.dart';
import 'package:package_info/package_info.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final InAppReview _inAppReview = InAppReview.instance;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _initAppVersion();
  }

  void _initAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      // _appVersion = 'v${packageInfo.version} (${packageInfo.buildNumber})';
      _appVersion = 'v${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(context),
      child: Column(
        children: [
          BannerAdWidget(adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_MENU')),
          Expanded(
            child: Container(
              color: CupertinoColors.systemGrey6,
              child: CupertinoScrollbar(
                child: ListView(
                  children: [
                    CupertinoListSection.insetGrouped(
                      backgroundColor: CupertinoColors.systemGrey6,
                      children: [
                        _menuItem("プッシュ通知設定", CupertinoIcons.bell,
                            _navigateToPushNotificationSettings),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      backgroundColor: CupertinoColors.systemGrey6,
                      children: [
                        _menuItem(
                            "レビューを送信", CupertinoIcons.star, _requestReview),
                        _menuItem("アプリをシェア", CupertinoIcons.share, _shareApp),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      backgroundColor: CupertinoColors.systemGrey6,
                      children: [
                        _menuItem("履歴", CupertinoIcons.person, () {
                          _navigateTo(context, const History());
                        }),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      backgroundColor: CupertinoColors.systemGrey6,
                      children: [
                        _menuItem("リアル大学生について", CupertinoIcons.person, () {
                          _navigateTo(context, const Profile());
                        }),
                        _menuItem("リアル大学生のSNS", CupertinoIcons.globe, () {
                          _navigateTo(context, const Sns());
                        }),
                      ],
                    ),
                    CupertinoListSection.insetGrouped(
                      backgroundColor: CupertinoColors.systemGrey6,
                      children: [
                        _menuItem("プライバシーポリシー", CupertinoIcons.lock, () {
                          _navigateTo(context, const Privacy());
                        }),
                        _menuItem(
                            "お問い合わせ", CupertinoIcons.mail, _launchMailApp),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _appVersion,
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar(BuildContext context) {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.white,
      middle: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
    );
  }

  CupertinoListTile _menuItem(String title, IconData icon, VoidCallback onTap) {
    return CupertinoListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: const CupertinoListTileChevron(),
      onTap: onTap,
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
      CupertinoPageRoute(builder: (context) => page),
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
