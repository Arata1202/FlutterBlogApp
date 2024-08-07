import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/article/index.dart';
import '../../../common/admob/banner/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('article_history') ?? [];
    });
  }

  void _removeFromHistory(String url) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history.remove(url);
      prefs.setStringList('article_history', _history);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Column(
        children: [
          BannerAdWidget(
            adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_HISTORY'),
          ),
          _buildHistoryList(),
          Expanded(child: Container(color: CupertinoColors.systemGrey6)),
        ],
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.white,
      middle: Image.asset(
        'assets/title.webp',
        height: 28,
      ),
    );
  }

  Widget _buildHistoryList() {
    return CupertinoListSection(
      header: Text(
        '履歴',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
      children: _history.isNotEmpty
          ? _history.take(5).map((url) {
              return CupertinoListTile(
                title: Text(url),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: CupertinoColors.systemGrey,
                  ),
                  onPressed: () {
                    _showActionSheet(context, url);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ArticlePage(url: url),
                    ),
                  );
                },
              );
            }).toList()
          : [
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  '履歴はありません。',
                  style: TextStyle(
                      color: CupertinoColors.systemGrey,
                      decoration: TextDecoration.none,
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
    );
  }

  void _showActionSheet(BuildContext context, String url) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(url),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              _removeFromHistory(url);
              Navigator.pop(context);
            },
            child: Text('削除する'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('キャンセル'),
        ),
      ),
    );
  }
}
