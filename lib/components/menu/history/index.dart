import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/article/index.dart';
import '../../../common/admob/banner/index.dart';
import '../../../common/admob/interstitial/index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

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
    _history = _history.reversed.toList();
    _trimHistoryToThree();
    setState(() {});
  }

  void _removeFromHistory(String url) async {
    _history.removeWhere((entry) => entry['url'] == url);
    _removeDuplicates();
    _trimHistoryToThree();
    List<String> updatedHistory =
        _history.map((entry) => '${entry['title']}|${entry['url']}').toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('article_history', updatedHistory);
    setState(() {});
  }

  void _trimHistoryToThree() {
    if (_history.length > 15) {
      _history = _history.take(15).toList();
    }
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
    if (isIOS) {
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
    } else {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            BannerAdWidget(
              adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_FAVORITES'),
            ),
            _buildHistoryList(),
          ],
        ),
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
      // ヘッダーの変色対策
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
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
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
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

  Widget _buildHistoryList() {
    if (isIOS) {
      return CupertinoListSection(
        header: Text(
          '閲覧履歴',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: CupertinoColors.black,
          ),
        ),
        children: _history.isNotEmpty
            ? _history.map((entry) {
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
                    '閲覧履歴はありません。',
                    style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        decoration: TextDecoration.none,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
      );
    } else {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '閲覧履歴',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _history.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        final entry = _history[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(entry['title'] ?? 'Unknown'),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert, color: Colors.grey),
                              onPressed: () {
                                _showActionSheet(context, entry['url']!,
                                    entry['title'] ?? 'Unknown');
                              },
                            ),
                            onTap: () {
                              _showInterstitialAd(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ArticlePage(url: entry['url']!),
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '閲覧履歴はありません。',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
          ],
        ),
      );
    }
  }

  void _showActionSheet(BuildContext context, String url, String title) {
    if (isIOS) {
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
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('削除する'),
                onTap: () {
                  _removeFromHistory(url);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('キャンセル'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _interstitialAdManager.dispose();
    super.dispose();
  }
}
