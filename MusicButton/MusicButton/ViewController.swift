//
//  ViewController.swift
//  MusicButton
//
//  Created by Himeno Kosei on 2016/06/15.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import MediaPlayer


enum ViewMode {
    case PLAY
    case SETTING
}

class ViewController: UIViewController, UIGestureRecognizerDelegate, MPMediaPickerControllerDelegate {
    
    // 現在の設定番号
    var customSettingId: Int = 0
    var soundPlayer:AVAudioPlayer!
    
    // 設定ビューを開いたかどうか
    var show_setting_frame_flag: Bool! = false
    // ピンチするサイズ
    let pinch_scale: CGFloat = 0.6
    
    // ミュージックボタンのデリゲートクラス
    var musicButtonDelegate: MusicButtonDelegate!
    // ボタンのビュー
    @IBOutlet var soundButtonCollectionView: UICollectionView!
    
    var settingViewConfig: SoundBoxTableConfig!
    // ロードした音楽を表示するテーブルビュー
    @IBOutlet var musicListView: UITableView!
    
    // パラメータービュー
    @IBOutlet var parameterView: ParameterView!
    
    // AutoLayout Values
    @IBOutlet weak var buttonPanelRightMargin: NSLayoutConstraint!
    @IBOutlet weak var buttonPanelBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var musicListViewTopMargin: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        // Todo: 最後に使用した設定を呼び出す | 現在は最後に登録された設定を呼び出すs
        if let last_use_setting = realm.objects(AppSetting).last {
            // データベースにデータが存在した場合はそれを使う。
            print("データが存在しました。呼びだされはカスタム設定は '\(last_use_setting.custom_id)' です。")
            self.customSettingId = last_use_setting.custom_id
        } else {
            // [初回起動時] 設定がなかった場合に、新規に作成する
            print("新規にデータを作成します。")
            let realm = try! Realm()
            let newSetting = AppSetting()
            newSetting.updateParams()
            
            try! realm.write ({
                realm.add(newSetting)
            })
            
            self.customSettingId = (realm.objects(AppSetting).last?.custom_id)!
        }
        
        // UICollectionViewCell の Delegate / DataSource の分割
        // http://qiita.com/asami_usa/items/059487f1f75906861453
        print("UICollectionViewの初期化開始")
        self.musicButtonDelegate = MusicButtonDelegate(collectView: self.soundButtonCollectionView, customSettingId: customSettingId)
        self.musicButtonDelegate.setup(self.soundButtonCollectionView, parameterView: parameterView)
        
        // UICollectionViewCellのサイズ調整
        // https://teratail.com/questions/8712
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2 // 列間
        layout.minimumLineSpacing = 5 // 行間
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        self.soundButtonCollectionView.collectionViewLayout = layout
        
        // MusicListView の Delegate / DataSource の分割
        print("MusicListViewの初期化開始")
        self.settingViewConfig = SoundBoxTableConfig()
        self.settingViewConfig.setup(self.musicListView)
        
        // AutoLayoutの更新
        self.buttonPanelBottomMargin.constant = 0
        self.buttonPanelRightMargin.constant = 0
        self.soundButtonCollectionView.layoutIfNeeded()
        self.musicListView.layoutIfNeeded()
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        // 画面が回転した時にUICollectionViewのレイアウトを再適用させる方法
        // http://stackoverflow.com/questions/13181217/animating-uicollectionview-on-orientation-changes
        self.soundButtonCollectionView.collectionViewLayout.invalidateLayout()
        
        self.buttonPanelRightMargin.constant = 0
        self.buttonPanelBottomMargin.constant = 0
        self.musicListViewTopMargin.constant = 0
        if (!CGAffineTransformIsIdentity(self.soundButtonCollectionView.transform)) {
            // 回転するときは強制的に元のサイズに戻す。
            //self.soundButtonCollectionView.transform = CGAffineTransformIdentity
            self.soundButtonCollectionView.layoutIfNeeded()
            self.musicListView.layoutIfNeeded()
        }
        
    }
    
    @IBAction func addSound() {
        let picker: MPMediaPickerController = MPMediaPickerController()
        picker.delegate = self
        // allowsPickingMultipleItemsは悩ましい。
        picker.allowsPickingMultipleItems = true
        picker.prompt = "音源を1つ選択して下さい。"
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func setMusicToButton() {
        /*
         Todo: MusicListにデータがない場合はボタンを無効化する。
         */
        print("\(#function) | データの永続化と表示")
        let realm = try! Realm()
        // [データの保存先を探索] 現在選択されているミュージックボタンの番号
        let currentSetting = realm.objects(AppSetting).filter("custom_id = \(self.customSettingId)").first
        let mBtnNum: Int = self.musicButtonDelegate.currentTapedCellIndexPath.row
        let updateBtn = (currentSetting?.music_buttons[mBtnNum])!
        // [保存データの取得] 選択されたテーブルビューの値を設定する
        let musicListId: Int = (self.settingViewConfig.currentSelectedMusicListIndex?.row)!
        let selectedMusic = (realm.objects(SoundBox).filter("id = \(musicListId + 1)").first)!
        // [保存実行]
        try! realm.write( {
            updateBtn.title = selectedMusic.title
            updateBtn.url = selectedMusic.save_path
            updateBtn.durationTime = selectedMusic.play_time
        })
        print("更新されました。")
        // [表示の反映]
        self.musicButtonDelegate.updateParameterView(self.musicButtonDelegate.currentTapedCellIndexPath)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        defer {
            dismissViewControllerAnimated(true, completion: nil)
            self.musicListView.reloadData()
        }
        
        let items = mediaItemCollection.items
        
        if items.isEmpty { return }
        
        // 重複配列を取り除く
        let realm = try! Realm()
        for _item in items {
            // idの重複チェック
            if (realm.objects(SoundBox).filter("save_path == '\(_item.assetURL!.absoluteString)'").first != nil ){
                // print("[\(idx)] 重複した値が存在しました。")
                continue
            }
            
            if (_item.playbackDuration > 3) {
                print("再生時間が3秒を越しています。")
                continue
            }
            
            let soundBoxItem = SoundBox()
            // Todo: idの作成をメソッド化(autoincrement)
            if let obj = realm.objects(SoundBox).last {
                soundBoxItem.id = obj.id + 1
            } else {
                soundBoxItem.id = 1
            }
            
            soundBoxItem.title = _item.title! as String
            soundBoxItem.save_path = _item.assetURL!.absoluteString
            soundBoxItem.favorite_star = _item.rating
            soundBoxItem.play_time = _item.playbackDuration
            
            try! realm.write({
                realm.add(soundBoxItem)
            })
            
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ジェスチャーの登録
    
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if recognizer.view != nil {
            //print("recognizer.scale = \(recognizer.scale)")
            //print("show setting frame flag = \(self.show_setting_frame_flag)")
            //print("無変形？ \(CGAffineTransformIsIdentity(view.transform))\n")
            if self.show_setting_frame_flag && recognizer.scale > 1 {
                // UIViewのアニメーションの追加
                // https://sites.google.com/a/gclue.jp/swift-docs/ni-yinki100-ios/uikit/animeshonwoendoresu-zai-shengsuru
                // AutoLayoutのアニメーション
                // http://qiita.com/roana0229/items/6a3272151262ea89e9ff
                self.buttonPanelRightMargin.constant = 0
                self.buttonPanelBottomMargin.constant = 0
                UIView.animateWithDuration(0.3, animations: {
                    () -> Void in
                    self.view.layoutIfNeeded()
                    self.soundButtonCollectionView.reloadData()
                    }, completion: nil)
                self.show_setting_frame_flag = false
            } else if recognizer.scale < 1 && self.buttonPanelRightMargin.constant == 0 {
                // AutoLayoutのアニメーション
                self.buttonPanelRightMargin.constant = self.soundButtonCollectionView.frame.width * (1-self.pinch_scale)
                self.buttonPanelBottomMargin.constant = self.soundButtonCollectionView.frame.height * (1-self.pinch_scale)
                UIView.animateWithDuration(0.3, animations: {
                    () -> Void in
                    self.view.layoutIfNeeded()
                    self.soundButtonCollectionView.reloadData()
                    }, completion: nil)
                
                self.show_setting_frame_flag = true
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




