# MusicButton

![MusicButton ICON](MusicButton/Assets.xcassets/AppIcon.appiconset/MusicButton-60@3x.png)



# UICollectionView

## UICollectionViewFlowLayout

- [iOS UICollecionViewFlowLayout でカスタムレイアウトを作ろう 〜 Swift版](http://www.indetail.co.jp/blog/5257/)
- [UITableView・UICollectionView攻略](http://cccookie.hatenablog.com/entry/2014/01/08/104544)
- [【iOS】UITableViewでCardUIを実装してみる](http://tech.admax.ninja/2014/10/30/how-to-make-card-ui/)

# Subview / XIBファイル関連

## UIView内のsubviewの重なり順を変更する

参考: https://ideacloud.co.jp/dev/addsubview_index.html

self.view.sendSubviewToBack(subview)

### subViewの削除

subview.removeFromSuperview()

よくわからないメソッド

willRemoveSubview(subview)


## AutoLayoutとアニメーション

- [iOS, AutoLayoutで簡単にできるアニメーション](http://qiita.com/roana0229/items/6a3272151262ea89e9ff)
- [Qiita: AutoLayoutでアニメーションを設定する方法(Swift版)](http://qiita.com/bohemian916/items/fffdd81fc70199379d85)

### アニメーション

- [Creating Simple View Animations in Swift](http://www.appcoda.com/view-animation-in-swift/)

# UITableView / UICollectionView

- [[iPhone] UITableView をストーリボードで作る (Swift)](https://akira-watson.com/iphone/tableview_2_2.html)

## 曲の取得

- [UITableViewに曲の情報を表示](http://seeku.hateblo.jp/entry/2015/06/20/090022)

## Delegate / DataSourceの分離

- [UICollectionViewのDataSourceとDelegateをControllerと別のファイルに記述する](http://qiita.com/asami_usa/items/059487f1f75906861453)
- [swiftでDelegate/DataSourceを分離したいときに気をつけること](http://qiita.com/inuscript/items/13133d4318f87ff0acb5)

## Cellの更新

- [Teratail: CollectionViewのCellの見た目 位置,サイズなどを動的にしたい.](https://teratail.com/questions/22407)


## UICollectionViewCellのSubViewが初期化時に位置とサイズが変更できない問題

**原因**

- AutoLayoutとの共存ができない。

**対処方法**

- [Qiita: UICollectionViewCellでは作成時にsubviewの位置の変更が出来ない](http://qiita.com/kawanabe/items/873a1274ba78ce8ebe18)

xibファイルに分離して読みだす。

- [Qiita: xibファイルを呼び出す最も簡単な方法](http://qiita.com/iKichiemon/items/3cfa6c2bf2a0acb299a0)

# その他テクニック

## 遅延時間を使う

参考: http://studio.beatnix.co.jp/develop/swift/delay/

let delay = 1.0 * Double(NSEC_PER_SEC)
let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay)) dispatch_after(time, dispatch_get_main_queue(), {
// 処理
})