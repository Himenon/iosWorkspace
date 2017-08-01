//
//  SoundCellDelegate.swift
//  MusicButton
//
//  Created by Himeno Kosei on 2016/06/20.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import MediaPlayer

/*
 ミュージックボタンが押された時の処理を主に行うクラス
 - ボタンのイベント処理
 -
 */
enum MusicButtonEvent {
    case SELECT
    case DESELECT
}

class MusicButtonDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout, AVAudioPlayerDelegate {
    var customSettingId: Int = 0
    var cell_col_nums: CGFloat!
    var cell_row_nums: CGFloat!
    var parameterView: ParameterView!
    
    var cellAudioPlayer: [AVAudioPlayer!] = []
    
    var collectView: UICollectionView!
    let light_purple: UIColor = UIColor(red: 0.276, green: 0.166, blue: 0.804, alpha: 1)
    let selected_color: UIColor = UIColor(red: 0.906, green: 0.418, blue: 0.601, alpha: 1)
    
    // ボタンに音源を登録
    var multi_sound: [AVAudioPlayer!] = []
    
    // 現在選択中のセルのインデックス (設定の登録先を呼び出す用として使用)
    var currentTapedCellIndexPath: NSIndexPath!
    
    init(collectView: UICollectionView, customSettingId: Int) {
        print("MusicButtonDelegateの初期化を行います。")
        let realm = try! Realm()
        let customSetting = realm.objects(AppSetting).filter("custom_id = \(customSettingId)").first
        self.cell_col_nums = CGFloat( customSetting!.cell_col_nums )
        self.cell_row_nums = CGFloat( customSetting!.cell_row_nums )
        self.collectView = collectView
        self.customSettingId = customSettingId // 現在のAppSettingの値
        print("MusicButtonDelegateの初期化終了")
    }
    
    func setup(collectionView: UICollectionView, parameterView: ParameterView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.parameterView = parameterView
    }
    
    // FlowLayoutの設定
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let defaultMargin: CGFloat = 20
        let cell_width: CGFloat = (min(self.collectView.frame.size.width, self.collectView.frame.size.height) - defaultMargin) / self.cell_col_nums
        let cell_height: CGFloat = cell_width
        return CGSizeMake(cell_width, cell_height)
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:SoundBtnCell = collectionView.dequeueReusableCellWithReuseIdentifier("soundBtnCell", forIndexPath: indexPath) as! SoundBtnCell
        cell.cellNumber.text = String(indexPath.row)
        self.setCellColor(cell, indexPath: indexPath)
        cell.updateFrame()
        return cell
    }
    
    // FlowLayoutの設定
    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        //print("[\(indexPath.row)] セルが出現しました")
        let cell:SoundBtnCell = self.collectView.cellForItemAtIndexPath(indexPath) as! SoundBtnCell
        self.setCellColor(cell, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // print("[\(indexPath.row)] セルが表示領域より外側に行きました。")
        self.setCellColor(cell, indexPath: indexPath)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        // https://realm.io/jp/docs/swift/latest/#section-8
        let realm = try! Realm()
        
        // custom_idの設定を呼び出す
        print("現在のカスタム設定を呼び出します。 --- [\(self.customSettingId)]")
        print("登録されたデータからセルを生成します。")
        let appSetting = realm.objects(AppSetting).filter("custom_id = \(self.customSettingId)").first!
        
        if multi_sound.count == appSetting.cell_total {
            multi_sound = []
        }
        
        for music_item in appSetting.music_buttons {
            if music_item.url != "" {
                // Todo 音源がない場合を考える
                let player = try! AVAudioPlayer(contentsOfURL:NSURL(string: music_item.url)!)
                print("duration = \(player.duration)")
                multi_sound.append( player )
            } else {
                let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("sample001", ofType: "mp3")!)
                multi_sound.append( try! AVAudioPlayer(contentsOfURL: audioPath) )
            }
        }
        
        for player in multi_sound {
            player.prepareToPlay()
            // player.enableRate = true
            // player.rate = Float(player.duration) / 0.3 // 0.3秒に規格化
        }
        
        // appSettingに登録されているボタンの数を返す
        return appSetting.cell_total
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        /*
         Musicボタンのタッチイベント
         音楽を鳴らすのもこちら。
         設定画面の場合は、ParameterViewに現在の設定値を表示。
         セルをタップ > MusicListのセルをタップ > 登録
         */
        NSLog("\(#function): Select Event")
        let currentPlayer = multi_sound[indexPath.row]
        if currentPlayer.playing {
            // http://stackoverflow.com/questions/1161148/avaudioplayer-resetting-currently-playing-sound-and-playing-it-from-beginning
            currentPlayer.stop()
            currentPlayer.currentTime = 0
        }
        currentPlayer.play()
        
        // 現在のセルのNSIndexPathを更新する
        self.currentTapedCellIndexPath = indexPath
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        // セルの色を変更
        self.tapAnimation(cell)
        // self.selectedCellChangeColor(cell, mode: .SELECT)
        // ParameterViewの更新
        updateParameterView(indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        self.selectedCellChangeColor(cell, mode: .DESELECT)
    }
    
    func updateParameterView(indexPath: NSIndexPath) {
        let realm = try! Realm()
        let item = realm.objects(AppSetting).filter("custom_id == \(self.customSettingId)").first!
        
        self.parameterView.titleLabel.text = item.music_buttons[indexPath.row].title
        self.parameterView.durationLabel.text = String(item.music_buttons[indexPath.row].durationTime)
    }
    
    func setCellColor(cell: UICollectionViewCell, indexPath: NSIndexPath) -> UICollectionViewCell {
        /*
         セルの色を設定する場所。現在はチェック柄にしている。
         */
        let _current_cell_num = indexPath.row
        let _current_col_nums = _current_cell_num % Int(self.cell_col_nums)
        let _current_row_nums = _current_cell_num / Int(self.cell_col_nums)
        if _current_row_nums % 2 == 0 {
            if _current_col_nums % 2 == 0 { cell.backgroundColor = light_purple }
        } else {
            if _current_col_nums % 2 != 0 { cell.backgroundColor = light_purple }
        }
        return cell
    }
    
    func selectedCellChangeColor(cell: UICollectionViewCell, mode: MusicButtonEvent) {
        var changeColor = UIColor()
        
        switch mode {
        case .SELECT:
            changeColor = self.selected_color
        case .DESELECT:
            changeColor = self.light_purple
        }
        
        UIView.animateWithDuration(0.33, animations: {
            () -> Void in
            cell.backgroundColor = changeColor
        })
    }
    
    func tapAnimation(cell: UICollectionViewCell) {
        // http://mathewsanders.com/animations-in-swift-part-two/
        let duration = 0.2
        let delay = 0.0
        UIView.animateKeyframesWithDuration(duration,
                                            delay: delay,
                                            options: .BeginFromCurrentState,
                                            animations: {
                                                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: duration/2, animations: {
                                                cell.backgroundColor = self.selected_color
                                                })
                                                UIView.addKeyframeWithRelativeStartTime(duration/2, relativeDuration: duration/2, animations: {
                                                cell.backgroundColor = self.light_purple
                                                })
            },
                                            completion: nil)
        
    }
    
}