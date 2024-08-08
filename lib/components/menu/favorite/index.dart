import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../app/article/index.dart';
import '../../../common/admob/banner/index.dart';
import '../../../common/admob/interstitial/index.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Map<String, String>> _favorites = [];
  late InterstitialAdManager _interstitialAdManager;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _interstitialAdManager = InterstitialAdManager();
    _loadInterstitialAd();
    _loadFavorites();
  }

  void _loadInterstitialAd() {
    _interstitialAdManager.loadInterstitialAd(
      dotenv.get('PRODUCTION_INTERSTITIAL_AD_ID_FAVORITES'),
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

  void _loadFavorites() async {
    _favorites = await FavoritesManager.getFavorites();
    setState(() {});
  }

  void _removeFromFavorites(String url) async {
    await FavoritesManager.removeFavorite(url);
    _favorites.removeWhere((entry) => entry['url'] == url);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: Column(
        children: [
          BannerAdWidget(
            adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_FAVORITES'),
          ),
          _buildFavoritesList(),
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

  Widget _buildFavoritesList() {
    return CupertinoListSection(
      header: Text(
        'お気に入り',
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: CupertinoColors.black,
        ),
      ),
      children: _favorites.isNotEmpty
          ? _favorites.map((entry) {
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
                  'お気に入りはありません。',
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
              _removeFromFavorites(url);
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
