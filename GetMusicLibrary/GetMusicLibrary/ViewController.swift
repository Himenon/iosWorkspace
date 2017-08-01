//
//  ViewController.swift
//  GetMusicLibrary
//
//  Created by Himeno Kosei on 2016/06/22.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import RealmSwift


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet var musicTableList: UITableView!
    var multi_sonund: [AVAudioPlayer!] = []
    var _lastSelectedPath: NSIndexPath?
    
    
    // 初期化
    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicTableList.delegate = self
        self.musicTableList.dataSource = self
        
        // マイグレーション
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        // Realm Swiftのまとめ
        // http://qiita.com/See_Ku/items/6211690df3c56255fde4#%E3%83%9E%E3%82%A4%E3%82%B0%E3%83%AC%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ------------------ Start: TableViewの設定 ------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // プレイリストの作成
        let realm = try! Realm()
        let playlist = realm.objects(MusicPlayList)
        for (idx, player) in playlist.enumerate() {
            multi_sonund.append( try! AVAudioPlayer(contentsOfURL:NSURL(string: player.alubm_url)!) )
            multi_sonund[idx].delegate = self
            multi_sonund[idx].prepareToPlay()
        }
        
        return playlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // fatal error: unexpectedly found nil while unwrapping an Optional value
        // http://stackoverflow.com/questions/24833391/simple-uitableview-in-swift-unexpectedly-found-nil
        
        // ??を使う
        // http://stackoverflow.com/questions/34203044/defining-uitableviewcell-variable-in-swift-2-0
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("music_list_cell")!
        // ?? UITableViewCell(style: .Default, reuseIdentifier: simpleTableIdentifier) cell.textLabel?.text = dwarves[indexPath.row]
        // セルの使い回しについて
        // http://blog.morizotter.com/2013/12/24/uitableview-customcell-storyboard/
        // let cell = tableView.dequeueReusableCellWithIdentifier("BookCell") as BookTableViewCell
        // let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookTableViewCell
        // func dequeueReusableCellWithIdentifier(identifier: String!) -> AnyObject!
        // Used by the delegate to acquire an already allocated cell, in lieu of allocating a new one.
        
        // Realmから呼び出し
        let realm = try! Realm()
        // Todo: indexPath.rowとrealm.objectsの対応関係
        let playlist = realm.objects(MusicPlayList).filter("id == " + String(Int(indexPath.row) + 1)).first
        cell.textLabel?.text = (playlist?.alubm_title)!
        if let thumbnail = playlist?.alubm_thumbnail {
            cell.imageView?.image = UIImage(data: thumbnail)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("indexPath.row = \(indexPath.row)")
        // CELLがタップされた時の処理
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if self._lastSelectedPath != nil {
            if let lastSelectedCell = tableView.cellForRowAtIndexPath(self._lastSelectedPath!) {
                print("画面内にCellがあったので、チェックマークを消しました")
                lastSelectedCell.accessoryType = .None
            }
        }
        self._lastSelectedPath = indexPath
        cell.accessoryType = .Checkmark
        // Realmに保存された url から NSURL を作成
        // http://qiita.com/matsuyoro/items/991d06d407fffa70bd4d
        
        // 音源の再生 / 停止
        let realm = try! Realm()
        let playlist = realm.objects(MusicPlayList).filter("id == " + String(Int(indexPath.row) + 1)).first
        let soundPlayer = self.multi_sonund[(playlist?.id)! - 1]
        print("Playing Music? -> \(soundPlayer.playing)")
        if soundPlayer.playing {
            soundPlayer.stop()
        } else {
            soundPlayer.play()
        }
        
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // _lastSelectedPathが含まれるセルが消滅しようとした時に、チェックマークを外す
        if indexPath == _lastSelectedPath {
            // print("\(indexPath.row) -- にチェックマークを消しました！")
            cell.accessoryType = .None
        }
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // _lastSectedPathが含まれていたら再度チェックマークを入れる
        if indexPath == _lastSelectedPath {
            // print("\(indexPath.row) -- にチェックマークを入れました！")
            cell.accessoryType = .Checkmark
        }
    }
    
    // ------------------ Finish: TableViewの設定 ------------------
    
    // ------------------ Start: Music Component ------------------
    
    @IBAction func playMusic() {
        
    }
    
    @IBAction func stopMusic() {
        
    }
    
    @IBAction func allClear() {
        let realm = try! Realm()
        try! realm.write({
            realm.deleteAll()
        })
        self.musicTableList.reloadData()
    }
    
    // ------------------ Finish: Music Component ------------------
    
    // ------------------ Start: MediaPlayer ------------------
    
    @IBAction func addMusic() {
        let picker: MPMediaPickerController = MPMediaPickerController()
        picker.delegate = self
        // allowsPickingMultipleItemsは悩ましい。
        picker.allowsPickingMultipleItems = true
        picker.prompt = "音源を1つ選択して下さい。"
        presentViewController(picker, animated: true, completion: nil)
    }
    
    // ------------------ Finish: MediaPlayer ------------------
    
    // ------------------ Start: MediaPicker & RealmSetting ------------------
    
    func mediaPicker(mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        defer {
            // スコープを抜けるときに処理される。
            // http://qiita.com/takebayashi/items/541db03c7449ee41fd36
            dismissViewControllerAnimated(true, completion: nil)
            self.musicTableList.reloadData()
        }
        
        let items = mediaItemCollection.items
        
        if items.isEmpty { return }
        
        // 重複配列を取り除く
        let realm = try! Realm()
        for _item in items {
            // 重複チェック
            if (realm.objects(MusicPlayList).filter("alubm_url == '\(_item.assetURL!.absoluteString)'").first != nil ){
                // print("[\(idx)] 重複した値が存在しました。")
                continue
            }
            let new_album_info = MusicPlayList()
            // Todo: idの作成をメソッド化(autoincrement)
            if let obj = realm.objects(MusicPlayList).last {
                new_album_info.id = obj.id + 1
            } else {
                new_album_info.id = 1
            }
            // アルバムタイトルの取得
            new_album_info.alubm_title = _item.title! as String
            // NSURLをStringに変換する
            // http://stackoverflow.com/questions/33510541/how-to-convert-nsurl-to-string-in-swift
            new_album_info.alubm_url = _item.assetURL!.absoluteString
            
            // アルバムの画像を取得
            // Realmに画像をNSDataとして保存する方法: http://qiita.com/_ha1f/items/593ca4f9c97ae697fc75
            if (_item.artwork != nil) {
                let save_image: UIImage = (_item.artwork?.imageWithSize(CGSize(width: 40, height: 40)))!
                new_album_info.alubm_thumbnail = UIImagePNGRepresentation( save_image )!
            } else {
                new_album_info.alubm_thumbnail = nil
            }
            // Realmデータベースに書き込み
            try! realm.write({
                realm.add(new_album_info)
            })
            
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // ------------------ Finish: MediaPicker & RealmSetting ------------------
}

