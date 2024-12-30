<div id="top"><h1>リアル大学生：モバイル</h1></div>

## 使用技術

<!-- シールド一覧 -->
<p style="display: inline">
  <img src="https://img.shields.io/badge/-Flutter-000000.svg?logo=flutter&style=for-the-badge">
  <img src="https://img.shields.io/badge/-Firebase-000000.svg?logo=firebase&style=for-the-badge">
  <img src="https://img.shields.io/badge/-Onesignal-000000.svg?logo=onesignal&style=for-the-badge">
  <img src="https://img.shields.io/badge/-Canva-000000.svg?logo=canva&style=for-the-badge">
  <img src="https://img.shields.io/badge/-Figma-000000.svg?logo=figma&style=for-the-badge">
  <img src="https://img.shields.io/badge/-Google AdMob-000000.svg?logo=googleadmob&style=for-the-badge">
  <img src="https://img.shields.io/badge/-Google Analytics-000000.svg?logo=googleanalytics&style=for-the-badge">
  <img src="https://img.shields.io/badge/-XCode-000000.svg?logo=xcode&style=for-the-badge">
  <img src="https://img.shields.io/badge/-Android Studio-000000.svg?logo=androidstudio&style=for-the-badge">
</p>

## 目次

1. [プロジェクトについて](#1-プロジェクトについて)
2. [環境](#2-環境)
3. [ディレクトリ構成](#3-ディレクトリ構成)
4. [開発環境構築](#4-開発環境構築)
4. [プレフィックス](#5-プレフィックス)

## 1. プロジェクトについて

大学生活やプログラミングに関する記事を公開している個人ブログ「リアル大学生」のモバイル版

  <p align="left">
    <br />
    <a href="https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103"><strong>App Store »</strong></a>
    <br />
    <a href="https://play.google.com/store/apps/details?id=com.realunivlog.flutterblogapp"><strong>Google Play »</strong></a>
    <br />
    <a href="https://www.figma.com/design/8abXv3H0UaRwCjkyy8lecU/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88?node-id=0-1&t=RxhblDmbNSeXsEgf-1"><strong>Figma »</strong></a>
    <br />
    <br />

<p align="right">(<a href="#top">トップへ</a>)</p>

## 2. 環境

<!-- 言語、フレームワーク、ミドルウェア、インフラの一覧とバージョンを記載 -->

| 主要なパッケージ  | バージョン |
| --------------------- | ---------- |
| flutter               | 3.22.3     |
| firebase_core               | 2.24.2     |
| onesignal_flutter               | 5.1.2     |
| google_mobile_ads               | 5.1.0     |

その他のパッケージのバージョンは`pubspec.yaml`を参照

<p align="right">(<a href="#top">トップへ</a>)</p>

## 3. ディレクトリ構成

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
    ├── last_article
    ├── navigate_out
    └── wake_lock
```

<p align="right">(<a href="#top">トップへ</a>)</p>

## 4. 開発環境構築

### 開発環境の構築と起動

.env ファイルを[環境変数一覧](#環境変数一覧)を元に作成

```
ONESIGNAL_APP_ID=
APP_PACKAGE_NAME=
PRODUCTION_BANNER_AD_ID_HOME=
PRODUCTION_BANNER_AD_ID_ARTICLE=
PRODUCTION_BANNER_AD_ID_SEARCH=
PRODUCTION_BANNER_AD_ID_SEARCH_RESULT=
PRODUCTION_BANNER_AD_ID_MENU=
PRODUCTION_BANNER_AD_ID_PROFILE=
PRODUCTION_BANNER_AD_ID_SNS=
PRODUCTION_BANNER_AD_ID_PRIVACY=
PRODUCTION_BANNER_AD_ID_HISTORY=
PRODUCTION_BANNER_AD_ID_FAVORITES=
PRODUCTION_BANNER_AD_ID_DISCLAIMER=
PRODUCTION_BANNER_AD_ID_COPYRIGHT=
PRODUCTION_BANNER_AD_ID_LINK=
PRODUCTION_INTERSTITIAL_AD_ID_HOME=
PRODUCTION_INTERSTITIAL_AD_ID_SEARCH=
PRODUCTION_INTERSTITIAL_AD_ID_HISTORY=
PRODUCTION_INTERSTITIAL_AD_ID_FAVORITES=
```

.env ファイルを作成後、以下のコマンドで開発環境を起動

```
flutter pub get
cd ios && pod install && cd ..
flutter run
```

### 動作確認

Xcode または Android Studio で起動できるか確認
起動できたら成功

### 環境変数一覧

| 変数名                 | 役割                                      |
| ---------------------- | ----------------------------------------- |
| ONESIGNAL_APP_ID | OneSignalのappId |
| APP_PACKAGE_NAME | Androidのパッケージ名 |
| PRODUCTION_BANNER_AD_ID_HOME | トップページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_ARTICLE | 記事ページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_SEARCH | 検索ページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_SEARCH_RESULT | 検索結果ページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_MENU | メニューページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_PROFILE | プロフィールページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_SNS | SNSページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_PRIVACY | プライバシーポリシーページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_HISTORY | 閲覧履歴ページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_FAVORITES | お気に入りページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_DISCLAIMER | 免責事項ページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_COPYRIGHT | 著作権ページのGoogle AdMobのバナー広告 |
| PRODUCTION_BANNER_AD_ID_LINK | リンクページのGoogle AdMobのバナー広告 |
| PRODUCTION_INTERSTITIAL_AD_ID_HOME | トップページのGoogle AdMobのインタースティシャル広告 |
| PRODUCTION_INTERSTITIAL_AD_ID_SEARCH | 検索ページのGoogle AdMobのインタースティシャル広告 |
| PRODUCTION_INTERSTITIAL_AD_ID_HISTORY | 履歴ページのGoogle AdMobのインタースティシャル広告 |
| PRODUCTION_INTERSTITIAL_AD_ID_FAVORITES | お気に入りページのGoogle AdMobのインタースティシャル広告 |

### コマンド一覧

| 主要なコマンド               | 実行する処理                                                            |
| ------------------- | ----------------------------------------------------------------------- |
| flutter pub get        | 依存関係のインストール |
| pod install          | CocoaPodsの依存関係をインストール                                                     |
| flutter run             | 開発環境の起動                                                          |
| flutter clean             | キャッシュの削除                                                          |

<p align="right">(<a href="#top">トップへ</a>)</p>

## 5. プレフィックス

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
