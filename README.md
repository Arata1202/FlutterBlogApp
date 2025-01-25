<div id="top"></div>

<div align="right">
  
![GitHub License](https://img.shields.io/github/license/Arata1202/FlutterBlogApp)

</div>

![title](/.docs/readme/images/title.png)

## 目次

- [リアル大学生：モバイル](#top)
  - [目次](#目次)
  - [リンク一覧](#リンク一覧)
  - [主な機能一覧](#主な機能一覧)
  - [使用技術](#使用技術)
  - [環境構築](#環境構築)
    - [リポジトリのクローン](#リポジトリのクローン)
    - [Flutter プロジェクトの起動](#Flutterプロジェクトの起動)
  - [ディレクトリ構成](#ディレクトリ構成)
  - [Git の運用](#Gitの運用)
    - [ブランチ](#ブランチ)
    - [コミットメッセージの記法](#コミットメッセージの記法)

## リンク一覧

<ul><li><a href="https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103">App Store</a></li></ul>
<ul><li><a href="https://play.google.com/store/apps/details?id=com.realunivlog.flutterblogapp">Google Play</a></li></ul>
<ul><li><a href="https://www.figma.com/design/8abXv3H0UaRwCjkyy8lecU/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88?node-id=0-1&t=RxhblDmbNSeXsEgf-1">Figma</a></li></ul>

<p align="right">(<a href="#top">トップへ</a>)</p>

## 主な機能一覧

※製品版では Google AdMob による広告が表示されます。

| 記事一覧ページ                                           | 　検索ページ                                               |
| -------------------------------------------------------- | ---------------------------------------------------------- |
| ![1](/.docs/readme/images/1.png)                         | ![2](/.docs/readme/images/2.png)                           |
| 最新記事やカテゴリーごとの記事を一覧表示するページです。 | キーワードやタグ、アーカイブから検索をすることができます。 |

| 記事ページ                                                                         | 　メニューページ                                                                   |
| ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| ![3](/.docs/readme/images/3.png)                                                   | ![4](/.docs/readme/images/4.png)                                                   |
| 記事を閲覧するためのページです。ネイティブなシェアボタンから記事をシェアできます。 | 設定項目や固定ページ（プロフィールや免責事項など）へのリンクなどを記載しています。 |

| 強制アップデート                                                                                           | 　プッシュ通知                                                                                         |
| ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ |
| ![5](/.docs/readme/images/5.png)                                                                           | ![6](/.docs/readme/images/6.png)                                                                       |
| Firebase の Remote Config を利用して、指定のバージョンより古い場合にダイアログを表示させることができます。 | OneSignal と Pipedream（Web Hook）を利用して、初回の記事公開時にプッシュ通知を送信することができます。 |

| iOS UI                                                                | 　 Android UI                                                        |
| --------------------------------------------------------------------- | -------------------------------------------------------------------- |
| ![4](/.docs/readme/images/4.png)                                      | ![7](/.docs/readme/images/7.png)                                     |
| Cupertino UI を使用して、ネイティブに寄せたデザインを再現しています。 | Material UI を使用して、ネイティブに寄せたデザインを再現しています。 |

<p align="right">(<a href="#top">トップへ</a>)</p>

## 使用技術

| Category | Technology Stack                            |
| -------- | ------------------------------------------- |
| Frontend | Flutter                                     |
| Backend  | Firebase                                    |
| Design   | Figma, Canva                                |
| Google   | AdMob, Analytics                            |
| etc.     | OneSignal, Pipedream, XCode, Android Studio |

<p align="right">(<a href="#top">トップへ</a>)</p>

## 環境構築

### リポジトリのクローン

```
# リポジトリのクローン
git clone git@github.com:Arata1202/FlutterBlogApp.git
cd FlutterBlogApp

# .env.exampleから.envを作成
mv .env.example .env

# .envの編集
vi .env

# Firebaseから必要なファイルを入手
cp GoogleService-Info.plist /ios/Runner
cp google-services.json /android/app
```

### Flutter プロジェクトの起動

```
# 依存関係のインストール
flutter pub get

# CocoaPodsのインストール
cd ios && pod install && cd ..

# Flutterプロジェクトの起動
flutter run
```

<p align="right">(<a href="#top">トップへ</a>)</p>

## ディレクトリ構成

```
❯ tree -a -I "node_modules|.next|.git|.pytest_cache|static" -L 2 lib
lib
├── app
│   ├── article
│   ├── home
│   ├── menu
│   ├── pagination
│   ├── search
│   └── search_result
├── common
│   └── admob
├── components
│   └── menu
├── layout
│   ├── footer
│   ├── main
│   └── splash
├── main.dart
└── util
    └── navigate_out
```

<p align="right">(<a href="#top">トップへ</a>)</p>

## Git の運用

### ブランチ

GitHub Flow を使用する。
master と feature ブランチで運用する。

| ブランチ名 |   役割   | 派生元 | マージ先 |
| :--------: | :------: | :----: | :------: |
|   master   | 本番環境 |   -    |    -     |
| feature/\* | 機能開発 | master |  master  |

### コミットメッセージの記法

```
fix: バグ修正
feat: 新機能追加
update: 機能更新
change: 仕様変更
perf: パフォーマンス改善
refactor: コードのリファクタリング
docs: ドキュメントのみの変更
style: コードのフォーマットに関する変更
test: テストコードの変更
revert: 変更の取り消し
chore: その他の変更
```

<p align="right">(<a href="#top">トップへ</a>)</p>
