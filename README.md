<div id="top"></div>

<div align="right">
  
![GitHub License](https://img.shields.io/github/license/Arata1202/FlutterBlogApp)

</div>

![title](https://github.com/user-attachments/assets/e3ba2618-58c2-4c67-ac0a-1d5cab1400f3)

## 目次
- [リアル大学生：モバイル](#top)
  - [目次](#目次)
  - [リンク一覧](#リンク一覧)
  - [主な機能一覧](#主な機能一覧)
  - [使用技術](#使用技術)
  - [環境構築](#環境構築)
    - [リポジトリのクローン](#リポジトリのクローン)
    - [Flutterプロジェクトの起動](#Flutterプロジェクトの起動)
  - [ディレクトリ構成](#ディレクトリ構成)
  - [Gitの運用](#Gitの運用)
    - [ブランチ](#ブランチ)
    - [コミットメッセージの記法](#コミットメッセージの記法)

## リンク一覧
<ul><li><a href="https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103">App Store</a></li></ul>
<ul><li><a href="https://play.google.com/store/apps/details?id=com.realunivlog.flutterblogapp">Google Play</a></li></ul>
<ul><li><a href="https://www.figma.com/design/8abXv3H0UaRwCjkyy8lecU/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88?node-id=0-1&t=RxhblDmbNSeXsEgf-1">Figma</a></li></ul>

<p align="right">(<a href="#top">トップへ</a>)</p>

## 主な機能一覧

※製品版ではGoogle AdMobによる広告が表示されます。

| 記事一覧ページ |　検索ページ |
| ---- | ---- |
| ![1](https://github.com/user-attachments/assets/2805fb78-5f88-45f2-9e41-813fa743d1d8) | ![2](https://github.com/user-attachments/assets/fe12b36d-1e56-4e1b-b48f-d52f3473c25c) |
| 最新記事やカテゴリーごとの記事を一覧表示するページです。 | キーワードやタグ、アーカイブから検索をすることができます。 |

| 記事ページ |　メニューページ	 |
| ---- | ---- |
| ![3](https://github.com/user-attachments/assets/3299e7ef-80f3-47f0-969b-19eb3bf41302) | ![4](https://github.com/user-attachments/assets/eb4cc96f-c971-4cfc-9b84-98913d06bfad) |
| 記事を閲覧するためのページです。ネイティブなシェアボタンから記事をシェアできます。 | 設定項目や固定ページ（プロフィールや免責事項など）へのリンクなどを記載しています。 |

| 強制アップデート |　プッシュ通知 |
| ---- | ---- |
| ![5](https://github.com/user-attachments/assets/b714d555-4541-4328-aa43-0d66ae8fadd1) | ![6](https://github.com/user-attachments/assets/e2f48213-95c8-4705-b387-5eefc3e0cd92) |
| FirebaseのRemote Configを利用して、指定のバージョンより古い場合にダイアログを表示させることができます。 | OneSignalとPipedream（Web Hook）を利用して、初回の記事公開時にプッシュ通知を送信することができます。 |

| iOS UI |　Android UI |
| ---- | ---- |
| ![4](https://github.com/user-attachments/assets/eb4cc96f-c971-4cfc-9b84-98913d06bfad) | ![7](https://github.com/user-attachments/assets/a5a515bb-e45b-4aa1-9bb2-2aefc445de26) |
| Cupertino UIを使用して、ネイティブに寄せたデザインを再現しています。 | Material UIを使用して、ネイティブに寄せたデザインを再現しています。 |

<p align="right">(<a href="#top">トップへ</a>)</p>

## 使用技術

| Category          | Technology Stack                              |
| ----------------- | --------------------------------------------- |
| Frontend          | Flutter                                       |
| Backend           | Firebase                                      |
| Design            | Figma, Canva                                  |
| Google            | AdMob, Analytics                              |
| etc.              | OneSignal, Pipedream, XCode, Android Studio                         |

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

### Flutterプロジェクトの起動

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

## Gitの運用

### ブランチ

GitHub Flowを使用する。
masterとfeatureブランチで運用する。

| ブランチ名 |   役割   | 派生元 | マージ先 |
| :--------: | :------: | :----: | :------: |
|    master    | 本番環境 |   -    |    -     |
| feature/\* | 機能開発 |  master  |   master   |

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
