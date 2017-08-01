# GetMusicLibrary

![GetMusicLibrary Icon](GetMusicLibrary/Assets.xcassets/AppIcon.appiconset/Icon-76@2x.png)

## Install

```
pod install
```

## Realmを使って、MusicLibraryから音源の取得などを実装

- [StacOverflow: How to convert NSURL to String in Swift](http://stackoverflow.com/questions/33510541/how-to-convert-nsurl-to-string-in-swift)

## Todo

### RealmSwiftを用いて、UITableViewCellに表示するデータ

### 重複配列を除去してAppendする方法

ジェネリックスを使用して、新たに定義する

```swift
struct UniqueArray<T: Equatable> {

    // http://tea-leaves.jp/swift/content/%E3%82%B8%E3%82%A7%E3%83%8D%E3%83%AA%E3%82%AF%E3%82%B9
    var items = [T] ()
    var count: Int {
        return items.count
    }

    // 構造体や列挙型のメソッドで値を変更する
    // http://tea-leaves.jp/swift/content/%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89
    mutating func append(item: T) {
        // Swift 2の変更 contains
        // http://stackoverflow.com/questions/30839733/cant-use-method-contains-in-swift-2
        if items.contains(item) {
            items.append(item)
        }
    }
}
```

### UITableViewList でチェックマークをラジオボタンのように、1つだけつけようとするときにハマったこと

セルの再利用により、チェックマークをつけたセルが、スクロールすることによってindexPathで参照できなかった。
次の記事

> [[iOS] UITableViewでラジオボタンを実現する](http://dev.classmethod.jp/smartphone/uitableviewradiobutton/)

では、画面での処理を記述していないため、うまく対応できない。


## 音を同時に出力する

- [[iOS][Swift]AVAudioPlayerを使う（複数の曲をあつかう）](http://nackpan.net/blog/2015/09/23/ios-swift-avaudioplayer-multiple-items/)
- [[iOS][Swift]AVAudioPlayerを使う（再生速度の変更、複数のプレイヤー）](http://nackpan.net/blog/2015/09/20/ios-wift-avaudioplayer-playback-rate-changer/)
- [【IOS】音楽を止めずに効果音を同時に再生するには](http://www.ecoop.net/memo/archives/ios_play_sounds_and_background_music_simultaneously.html)
- [６．音源の同時発生 | 実践的Swift入門](http://katochan.muse.weblife.me/facebook/AVAudioPlayer.html)
- [複数の音声ファイルを同時再生する方法(etc...)を調べて新作アプリをサブミットした話](http://qiita.com/anthrgrnwrld/items/b8e3330535d668384937)

### 見つけたもの

- [AVAudioUnit - Developer - Apple](https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVAudioUnit_Class/)
    - [SwiftとAudioUnitで音を鳴らす](http://qiita.com/naokitomita/items/519391026e06fd6e5930)
- [OpenAL](https://www.openal.org/)
