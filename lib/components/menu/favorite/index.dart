import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../app/article/index.dart';
import '../../../common/admob/banner/index.dart';
import 'dart:io' show Platform;

bool isAndroid = Platform.isAndroid;
bool isIOS = Platform.isIOS;

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Map<String, String>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
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
    if (isIOS) {
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
    } else {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            BannerAdWidget(
              adUnitId: dotenv.get('PRODUCTION_BANNER_AD_ID_FAVORITES'),
            ),
            _buildFavoritesList(),
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

  Widget _buildFavoritesList() {
    if (isIOS) {
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
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ArticlePage(url: entry['url']!),
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
    } else {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'お気に入り',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            _favorites.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        final entry = _favorites[index];
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ArticlePage(url: entry['url']!),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'お気に入りはありません。',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
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
                  _removeFromFavorites(url);
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
    super.dispose();
  }
}
