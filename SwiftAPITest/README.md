# 


参考記事：[AlamofireとSwiftyJSONでAPIを叩くチュートリアル](http://qiita.com/yuta-t/items/1b6dfe34fa8537cf3329)

## 前準備

### Homebrewのインストール

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Carthageのインストール


```sh
brew install carthage
```

## Clone

リポジトリをクローンします。

```sh
https://github.com/Himenon/SwiftAPITest.git
```

## ライブラリのインストール

Carthageを使ってライブラリのインストールをします。
プロジェクトのトップディレクトリに移動したのち、以下のコマンドを入力して下さい。

```sh
carthage update --platform iOS
```

終了後、xcodeprojファイルを開いて下さい。
もし、ライブラリ/フレームワークのライブラリのリンクが切れていた場合は再リンクしてください。