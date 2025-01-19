import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../common/admob/banner/index.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

class Sns extends StatefulWidget {
  const Sns({super.key});

  @override
  _SnsState createState() => _SnsState();
}

class _SnsState extends State<Sns> {
  @override
  void initState() {
    super.initState();
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
                          _menuItem(
                            "X（旧Twitter）",
                            const FaIcon(FontAwesomeIcons.twitter),
                            () {
                              _launchURL('https://x.com/Aokumoblog');
                            },
                          ),
                          _menuItem(
                            "Instagram",
                            const FaIcon(FontAwesomeIcons.instagram),
                            () {
                              _launchURL(
                                  'https://www.instagram.com/ao_realstudent/?hl=ja');
                            },
                          ),
                          _menuItem(
                            "GitHub",
                            const FaIcon(FontAwesomeIcons.github),
                            () {
                              _launchURL('https://github.com/Arata1202');
                            },
                          ),
                        ],
                      ),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: CupertinoColors.systemGrey6,
                        children: [
                          _menuItem(
                            "Buy Me a Coffee",
                            const FaIcon(FontAwesomeIcons.mugHot),
                            () {
                              _launchURL(
                                  'https://buymeacoffee.com/realunivlog');
                            },
                          ),
                        ],
                      ),
                      CupertinoListSection.insetGrouped(
                        backgroundColor: CupertinoColors.systemGrey6,
                        children: [
                          _menuItem(
                            "にほんブログ村",
                            const FaIcon(FontAwesomeIcons.crown),
                            () {
                              _launchURL(
                                  'https://blogmura.com/profiles/11190305/?p_cid=11190305&reader=11190305');
                            },
                          ),
                          _menuItem(
                            "人気ブログランキング",
                            const FaIcon(FontAwesomeIcons.crown),
                            () {
                              _launchURL('https://blog.with2.net/ranking/9011');
                            },
                          ),
                          _menuItem(
                            "FC2ブログランキング",
                            const FaIcon(FontAwesomeIcons.crown),
                            () {
                              _launchURL(
                                  'https://blogranking.fc2.com/in.php?id=1067087');
                            },
                          ),
                        ],
                      ),
                      // CupertinoListSection.insetGrouped(
                      //   backgroundColor: CupertinoColors.systemGrey6,
                      //   children: [
                      //     _menuItem(
                      //       "Suzuri",
                      //       const FaIcon(FontAwesomeIcons.shoppingBag),
                      //       () {
                      //         _launchURL('https://suzuri.jp/realunivlog');
                      //       },
                      //     ),
                      //   ],
                      // ),
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
                        _menuItem(
                          "X（旧Twitter）",
                          const FaIcon(FontAwesomeIcons.twitter),
                          () {
                            _launchURL('https://x.com/Aokumoblog');
                          },
                        ),
                        _menuItem(
                          "Instagram",
                          const FaIcon(FontAwesomeIcons.instagram),
                          () {
                            _launchURL(
                                'https://www.instagram.com/ao_realstudent/?hl=ja');
                          },
                        ),
                        _menuItem(
                          "GitHub",
                          const FaIcon(FontAwesomeIcons.github),
                          () {
                            _launchURL('https://github.com/Arata1202');
                          },
                        ),
                      ]),
                      // _buildListSection([
                      //   _menuItem(
                      //     "Suzuri",
                      //     const FaIcon(FontAwesomeIcons.shoppingBag),
                      //     () {
                      //       _launchURL('https://suzuri.jp/realunivlog');
                      //     },
                      //   ),
                      // ]),
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
      leading: CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(CupertinoIcons.back, color: CupertinoColors.activeBlue),
            SizedBox(width: 4),
            Text(
              '戻る',
              style: TextStyle(color: CupertinoColors.activeBlue),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title, Widget icon, VoidCallback onTap) {
    if (isIOS) {
      return CupertinoListTile(
        title: Text(title),
        leading: icon,
        trailing: const CupertinoListTileChevron(),
        onTap: onTap,
      );
    } else {
      return ListTile(
        title: Text(title),
        leading: icon,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      );
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildListSection(List<Widget> children) {
    if (isIOS) {
      return CupertinoListSection.insetGrouped(
        backgroundColor: CupertinoColors.systemGrey6,
        children: children,
      );
    } else {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: children,
        ),
      );
    }
  }

  Future<void> _launchURL(String webUrl) async {
    try {
      if (await canLaunch(webUrl)) {
        await launch(webUrl, forceSafariVC: false);
      } else {
        throw 'Could not launch $webUrl';
      }
    } catch (e) {
      print(e);
    }
  }
}
