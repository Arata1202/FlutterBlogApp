import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/article/index.dart';
import '../../../common/admob/banner/index.dart';
import '../../../common/admob/interstitial/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Map<String, String>> _history = [];
  late InterstitialAdManager _interstitialAdManager;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _interstitialAdManager = InterstitialAdManager();
    _loadInterstitialAd();
    _loadHistory();
  }

  void _loadInterstitialAd() {
    _interstitialAdManager.loadInterstitialAd(
      dotenv.get('PRODUCTION_INTERSTITIAL_AD_ID_HISTORY'),
      () => setState(() => _isInterstitialAdReady = true),
    );
  }

  void _showInterstitialAd(VoidCallback onAdClosed) {
    if (_isInterstitialAdReady) {
      _interstitialAdManager.showInterstitialAd().then((_) {
        onAdClosed();
      }).catchError((error) {
        print('Failed to show interstitial ad: $error');
        onAdClosed();
      });
    } else {
      print('Interstitial ad is not ready yet');
      onAdClosed();
    }
  }

  void _loadHistory() async {
    _history = await ArticleHistoryManager.getArticleHistory();
    _removeDuplicates();
    setState(() {});
  }

  void _removeFromHistory(String url) async {
    _history.removeWhere((entry) => entry['url'] == url);
    _removeDuplicates();
    List<String> updatedHistory =
        _history.map((entry) => '${entry['title']}|${entry['url']}').toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('article_history', updatedHistory);
    setState(() {});
  }

  void _removeDuplicates() {
    Map<String, Map<String, String>> uniqueHistory = {};
    for (var entry in _history) {
      if (!uniqueHistory.containsKey(entry['title'])) {
        uniqueHistory[entry['title']!] = entry;
      }
    }
    _history = uniqueHistory.values.toList();
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
          ? _history.take(5).map((entry) {
              return CupertinoListTile(
                title: Text(entry['title'] ?? 'Unknown'),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: CupertinoColors.systemGrey,
                  ),
                  onPressed: () {
                    _showActionSheet(
                        context, entry['url']!, entry['title'] ?? 'Unknown');
                  },
                ),
                onTap: () {
                  _showInterstitialAd(() {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ArticlePage(url: entry['url']!),
                      ),
                    );
                  });
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

  void _showActionSheet(BuildContext context, String url, String title) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text('$title'),
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

  @override
  void dispose() {
    _interstitialAdManager.dispose();
    super.dispose();
  }
}