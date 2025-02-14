import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../components/menu/profile/index.dart';
import '../../components/menu/privacy/index.dart';
import '../../components/menu/disclaimer/index.dart';
import '../../components/menu/copyright/index.dart';
import '../../components/menu/link/index.dart';
import '../../components/menu/sns/index.dart';
import '../../components/menu/contact/index.dart';
import '../../common/admob/banner/index.dart';
import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;
import 'package:app_settings/app_settings.dart';

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

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
      _appVersion = 'v${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(context),
        child: Column(
          children: [
            BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
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
                          _menuItem("プロフィール", CupertinoIcons.person_circle, () {
                            _navigateTo(context, const Profile());
                          }),
                          _menuItem("SNS", CupertinoIcons.globe, () {
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
                              "免責事項", CupertinoIcons.exclamationmark_circle,
                              () {
                            _navigateTo(context, const Disclaimer());
                          }),
                          _menuItem("著作権", CupertinoIcons.doc_text, () {
                            _navigateTo(context, const Copyright());
                          }),
                          _menuItem("リンク", CupertinoIcons.link, () {
                            _navigateTo(context, const Link());
                          }),
                        ],
                      ),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: CupertinoColors.systemGrey6,
                        children: [
                          _menuItem("お問い合わせ", CupertinoIcons.mail, () {
                            _navigateTo(context, const Contact());
                          }),
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
    } else {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            BannerAdWidget(adUnitId: dotenv.get('BANNER_AD')),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Scrollbar(
                  child: ListView(
                    children: [
                      _buildListSection([
                        _menuItem("プッシュ通知設定", Icons.notifications, () {
                          _navigateToPushNotificationSettings();
                        }),
                      ]),
                      _buildListSection([
                        _menuItem("レビューを送信", Icons.star, () {
                          _requestReview();
                        }),
                        _menuItem("アプリをシェア", Icons.share, () {
                          _shareApp();
                        }),
                      ]),
                      _buildListSection([
                        _menuItem("プロフィール", Icons.account_circle, () {
                          _navigateTo(context, const Profile());
                        }),
                        _menuItem("SNS", Icons.language, () {
                          _navigateTo(context, const Sns());
                        }),
                      ]),
                      _buildListSection([
                        _menuItem("プライバシーポリシー", Icons.lock, () {
                          _navigateTo(context, const Privacy());
                        }),
                        _menuItem("免責事項", Icons.error, () {
                          _navigateTo(context, const Disclaimer());
                        }),
                        _menuItem("著作権", Icons.description, () {
                          _navigateTo(context, const Copyright());
                        }),
                        _menuItem("リンク", Icons.link, () {
                          _navigateTo(context, const Link());
                        }),
                      ]),
                      _buildListSection([
                        _menuItem("お問い合わせ", Icons.mail, () {
                          _navigateTo(context, const Contact());
                        }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _appVersion,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
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

  Widget _menuItem(String title, IconData icon, VoidCallback onTap) {
    if (isIOS) {
      return CupertinoListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: const CupertinoListTileChevron(),
        onTap: onTap,
      );
    } else {
      return ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
      title: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      centerTitle: true,
    );
  }

  Widget _buildListSection(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: children,
      ),
    );
  }

  void _shareApp() {
    final String appUrl = isIOS
        ? 'https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103'
        : 'https://play.google.com/store/apps/details?id=com.realunivlog.flutterblogapp';
    Share.share(
      'リアル大学生：モバイル\n$appUrl',
      subject: 'リアル大学生：モバイル',
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    if (isIOS) {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => page),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );
    }
  }

  void _navigateToPushNotificationSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void _requestReview() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.requestReview();
    } else {
      print('In-app review not available');
    }
  }
}
