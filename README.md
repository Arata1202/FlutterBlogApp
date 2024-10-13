## アーキテクチャ

![fluttern](https://github.com/user-attachments/assets/2fe96c21-ea8a-4232-990d-71437f673135)

## リンク集

### AppStore

- https://apps.apple.com/jp/app/%E3%83%AA%E3%82%A2%E3%83%AB%E5%A4%A7%E5%AD%A6%E7%94%9F-%E3%83%A2%E3%83%90%E3%82%A4%E3%83%AB/id6590619103

### GooglePlay

- https://play.google.com/store/apps/details?id=com.realunivlog.flutterblogapp

## 開発方法

まずは.env.example を.env に変更し、適切に設定する。

```
flutter pub get
cd ios && pod install && cd ..
flutter run
```

<!-- または

```
chmod +x pod.sh
./pod.sh
``` -->

## 実装機能

### ネイティブ

- GoogleAdMob
  - バナー広告
  - インタースティシャル広告
- Onesignal
  - プッシュ通知
- お気に入り機能
- 履歴閲覧機能
- Firebase
  - GoogleAnalytics
  - RemoteConfig
    - メンテナンス機能
    - 強制アップデート

## 技術構成

- Flutter
- Xcode
- Android Studio
- GitHub
- Canva
- Figma

## 料金

- Apple Developer Program（年間 約 12000 円）
- Google Developers （買い切り 約 4000円）
