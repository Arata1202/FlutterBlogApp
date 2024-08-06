import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          BannerAdWidget(adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_SNS')),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  _menuItem("X", const FaIcon(FontAwesomeIcons.twitter), () {
                    _launchURL('https://x.com/Aokumoblog');
                  }),
                  _divider(),
                  _menuItem(
                      "Instagram", const FaIcon(FontAwesomeIcons.instagram),
                      () {
                    _launchURL(
                        'https://www.instagram.com/ao_realstudent/?hl=ja');
                  }),
                  _divider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 4,
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(40.0),
      //   child: Padding(
      //     padding: const EdgeInsets.only(bottom: 8.0),
      //     child: const Text(
      //       '筆者のSNS',
      //       style: TextStyle(
      //         color: Colors.black,
      //         fontSize: 15,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _menuItem(String title, Widget icon, VoidCallback onTap) {
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
