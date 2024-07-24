import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile.dart';
import 'notice.dart';
import 'privacy.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('メニュー'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 4,
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
              _menuItem("プッシュ通知設定", const Icon(Icons.notifications), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Notice()),
                );
              }),
              _menuItem("お問い合わせ", const Icon(Icons.email), () {
                _launchMailApp();
              }),
              _menuItem("プライバシーポリシー", const Icon(Icons.privacy_tip), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Privacy()),
                );
              }),
            ],
          ),
        ));
  }

  Widget _menuItem(String title, Icon icon, VoidCallback onTap) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10.0),
              child: icon,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 18.0),
            ),
          ],
        ),
      ),
      onTap: onTap,
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
}
