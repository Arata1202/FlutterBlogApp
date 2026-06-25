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
            child: ListView(children: _buildCupertinoSections()),
          ),
        ),
      );
    } else {
      return AppPageScaffold(
        showBackButton: true,
        child: Container(
          color: Colors.grey[200],
          child: Scrollbar(child: ListView(children: _buildMaterialSections())),
        ),
      );
    }
  }

  List<Widget> _buildCupertinoSections() {
    return [
      _buildListSection([
        _menuItem("X", const FaIcon(FontAwesomeIcons.xTwitter), () {
          _launchURL('https://x.com/realunivlog');
        }),
        _menuItem("GitHub", const FaIcon(FontAwesomeIcons.github), () {
          _launchURL('https://github.com/Arata1202');
        }),
        _menuItem("Zenn", const _ZennIcon(), () {
          _launchURL('https://zenn.dev/realunivlog');
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
        _menuItem("X", const FaIcon(FontAwesomeIcons.xTwitter), () {
          _launchURL('https://x.com/realunivlog');
        }),
        _menuItem("GitHub", const FaIcon(FontAwesomeIcons.github), () {
          _launchURL('https://github.com/Arata1202');
        }),
        _menuItem("Zenn", const _ZennIcon(), () {
          _launchURL('https://zenn.dev/realunivlog');
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
        child: Column(children: children),
      );
    }
  }

  Future<void> _launchURL(String webUrl) async {
    await launchExternalUrl(webUrl);
  }
}

class _ZennIcon extends StatelessWidget {
  const _ZennIcon();

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final size = iconTheme.size ?? 24;

    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _ZennIconPainter(iconTheme.color ?? Colors.black),
      ),
    );
  }
}

class _ZennIconPainter extends CustomPainter {
  final Color color;

  const _ZennIconPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas
      ..save()
      ..scale(size.width / 88.3, size.height / 88.3);

    final firstPath = Path()
      ..moveTo(3.9, 83.3)
      ..relativeLineTo(17, 0)
      ..relativeCubicTo(0.9, 0, 1.7, -0.5, 2.2, -1.2)
      ..lineTo(69.9, 5.2)
      ..relativeCubicTo(0.6, -1, -0.1, -2.2, -1.3, -2.2)
      ..lineTo(52.5, 3)
      ..relativeCubicTo(-0.8, 0, -1.5, 0.4, -1.9, 1.1)
      ..lineTo(3.1, 81.9)
      ..cubicTo(2.8, 82.5, 3.2, 83.3, 3.9, 83.3)
      ..close();

    final secondPath = Path()
      ..moveTo(62.5, 82.1)
      ..relativeLineTo(22.1, -35.5)
      ..relativeCubicTo(0.7, -1.1, -0.1, -2.5, -1.4, -2.5)
      ..lineTo(67.2, 44.1)
      ..relativeCubicTo(-0.6, 0, -1.2, 0.3, -1.5, 0.8)
      ..lineTo(43, 81.2)
      ..relativeCubicTo(-0.6, 0.9, 0.1, 2.1, 1.2, 2.1)
      ..lineTo(60.5, 83.3)
      ..cubicTo(61.3, 83.3, 62.1, 82.9, 62.5, 82.1)
      ..close();

    canvas
      ..drawPath(firstPath, paint)
      ..drawPath(secondPath, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(_ZennIconPainter oldDelegate) =>
      color != oldDelegate.color;
}
