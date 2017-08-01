//
//  SettingView.swift
//  MusicButton
//
//  Created by Himeno Kosei on 2016/06/21.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import UIKit
import MediaPlayer
import Foundation
import RealmSwift

class SoundBoxTableConfig: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var currentSelectedMusicListIndex: NSIndexPath?
    
    func setup(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // セルの数をカウントするときの処理
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        let soundbox_items = realm.objects(SoundBox)
        return soundbox_items.count
    }
    
    // セルの作成時の処理
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの呼び出し
        let cell: SoundBoxTableCell = tableView.dequeueReusableCellWithIdentifier("soundItem", forIndexPath: indexPath) as! SoundBoxTableCell
        
        // Realmからデータを呼び出し
        let realm = try! Realm()
        let sound_item = realm.objects(SoundBox).filter("id == " + String(Int(indexPath.row) + 1)).first
        
        // セルにデータを表示
        cell.title.text = sound_item?.title
        cell.category.text = "Category" //sound_item?.categories[0].category
        cell.play_time.text = String( Double((sound_item?.play_time)!) ) + " sec."
        
        return cell
    }
    
    // タップ時の処理
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("MusicListがタップされました。")
        // 現在タップされているセルの位置を指定
        currentSelectedMusicListIndex = indexPath
    }
    
    // 画面にセルが表示された時の処理
    
    // 画面からセルが消えた時の処理
    
    
}