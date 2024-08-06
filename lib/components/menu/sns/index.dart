import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../common/admob/banner/index.dart';

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
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Column(
        children: [
          BannerAdWidget(adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_SNS')),
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
                          "X",
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

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      middle: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      backgroundColor: CupertinoColors.white,
      border: null,
    );
  }

  CupertinoListTile _menuItem(String title, Widget icon, VoidCallback onTap) {
    return CupertinoListTile(
      title: Text(title),
      leading: icon,
      trailing: const CupertinoListTileChevron(),
      onTap: onTap,
    );
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
