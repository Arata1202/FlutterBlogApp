![pic](https://github.com/user-attachments/assets/b86aa4fb-a38e-44ff-a64f-f1661926bc3d)

## 開発方法

まずは.env.example を.env に変更し、適切に設定する。

```
flutter pub get
cd ios && pod install && cd ..
flutter run
```

または

```
chmod +x pod.sh
./pod.sh
```

## 機能

### 実装機能（ネイティブ）

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
