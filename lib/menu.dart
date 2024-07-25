import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'profile.dart';
import 'notice.dart';
import 'privacy.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: const Text(
              'メニュー',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            _menuItem("筆者について", const Icon(Icons.person), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            }),
            _divider(),
            _menuItem("プッシュ通知設定", const Icon(Icons.notifications), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notice()),
              );
            }),
            _divider(),
            _menuItem("お問い合わせ", const Icon(Icons.email), () {
              _launchMailApp();
            }),
            _divider(),
            _menuItem("プライバシーポリシー", const Icon(Icons.privacy_tip), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Privacy()),
              );
            }),
            _divider(),
            _menuItem("アプリをシェア", const Icon(Icons.share), () {
              _shareApp();
            }),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(String title, Icon icon, VoidCallback onTap) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
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
      onTap: onTap,
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
      path: 'example@example.com',
      query: 'subject=問い合わせ&body=ここに本文を入力してください',
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
      'Check out this awesome app: [App Link]',
      subject: 'Awesome App',
    );
  }
}
