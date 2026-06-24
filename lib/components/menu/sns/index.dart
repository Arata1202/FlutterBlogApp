import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../common/page_scaffold/index.dart';
import '../../../util/launch_url/index.dart';
import '../../../util/platform/index.dart';

class Sns extends StatelessWidget {
  const Sns({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppPlatform.isIOS) {
      return AppPageScaffold(
        showBackButton: true,
        child: Container(
          color: CupertinoColors.systemGrey6,
          child: CupertinoScrollbar(
            child: ListView(
              children: _buildCupertinoSections(),
            ),
          ),
        ),
      );
    } else {
      return AppPageScaffold(
        showBackButton: true,
        child: Container(
          color: Colors.grey[200],
          child: Scrollbar(
            child: ListView(
              children: _buildMaterialSections(),
            ),
          ),
        ),
      );
    }
  }

  List<Widget> _buildCupertinoSections() {
    return [
      _buildListSection([
        _menuItem("X（旧Twitter）", const FaIcon(FontAwesomeIcons.xTwitter), () {
          _launchURL('https://x.com/Aokumoblog');
        }),
        _menuItem("Instagram", const FaIcon(FontAwesomeIcons.instagram), () {
          _launchURL('https://www.instagram.com/ao_realstudent/?hl=ja');
        }),
        _menuItem("GitHub", const FaIcon(FontAwesomeIcons.github), () {
          _launchURL('https://github.com/Arata1202');
        }),
      ]),
      _buildListSection([
        _menuItem("Buy Me a Coffee", const FaIcon(FontAwesomeIcons.mugHot), () {
          _launchURL('https://buymeacoffee.com/realunivlog');
        }),
      ]),
      _buildListSection([
        _menuItem("にほんブログ村", const FaIcon(FontAwesomeIcons.crown), () {
          _launchURL(
            'https://blogmura.com/profiles/11190305/?p_cid=11190305&reader=11190305',
          );
        }),
        _menuItem("人気ブログランキング", const FaIcon(FontAwesomeIcons.crown), () {
          _launchURL('https://blog.with2.net/ranking/9011');
        }),
        _menuItem("FC2ブログランキング", const FaIcon(FontAwesomeIcons.crown), () {
          _launchURL('https://blogranking.fc2.com/in.php?id=1067087');
        }),
      ]),
    ];
  }

  List<Widget> _buildMaterialSections() {
    return [
      _buildListSection([
        _menuItem("X（旧Twitter）", const FaIcon(FontAwesomeIcons.xTwitter), () {
          _launchURL('https://x.com/Aokumoblog');
        }),
        _menuItem("Instagram", const FaIcon(FontAwesomeIcons.instagram), () {
          _launchURL('https://www.instagram.com/ao_realstudent/?hl=ja');
        }),
        _menuItem("GitHub", const FaIcon(FontAwesomeIcons.github), () {
          _launchURL('https://github.com/Arata1202');
        }),
      ]),
      _buildListSection([
        _menuItem("Buy Me a Coffee", const FaIcon(FontAwesomeIcons.mugHot), () {
          _launchURL('https://buymeacoffee.com/realunivlog');
        }),
      ]),
      _buildListSection([
        _menuItem("にほんブログ村", const FaIcon(FontAwesomeIcons.crown), () {
          _launchURL(
            'https://blogmura.com/profiles/11190305/?p_cid=11190305&reader=11190305',
          );
        }),
        _menuItem("人気ブログランキング", const FaIcon(FontAwesomeIcons.crown), () {
          _launchURL('https://blog.with2.net/ranking/9011');
        }),
        _menuItem("FC2ブログランキング", const FaIcon(FontAwesomeIcons.crown), () {
          _launchURL('https://blogranking.fc2.com/in.php?id=1067087');
        }),
      ]),
    ];
  }

  Widget _menuItem(String title, Widget icon, VoidCallback onTap) {
    if (AppPlatform.isIOS) {
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

  Widget _buildListSection(List<Widget> children) {
    if (AppPlatform.isIOS) {
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
    await launchExternalUrl(webUrl);
  }
}
