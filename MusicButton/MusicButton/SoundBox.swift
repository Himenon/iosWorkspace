//
//  SoundBox.swift
//  MusicButton
//
//  Created by Himeno Kosei on 2016/06/26.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Foundation
import RealmSwift

class AppSetting: Object {
    /* 1つの設定に対して、SoundPlayButtonを多数持つ */
    
    // 音源の設定などはユーザーに任せる。
    // ボタンの数などが後で呼び出せる仕様
    
    dynamic var custom_id: Int = 1
    dynamic var cell_row_nums: Int = 3
    dynamic var cell_col_nums: Int = 3
    dynamic var cell_total: Int = 9

    dynamic var create_at = NSDate()
    dynamic var update_at = NSDate()
    dynamic var last_use_at = NSDate()
    
    // https://github.com/realm/realm-cocoa/issues/2814
    // dynamic var musicButtonParam: MusicButtonParameter!
    let music_buttons = List<MusicButton>()
    
    override static func primaryKey() -> String? {
        return "custom_id"
    }
    
    func updateParams() {
        if self.music_buttons.count != 0 {
            cell_total = cell_row_nums * cell_col_nums
        } else {
            print("一度、musicButtonParamを定義します。")
            for _ in 0 ... cell_col_nums * cell_row_nums {
                music_buttons.append(MusicButton())
            }
            self.updateParams()
        }
    }
}

class MusicButton: Object {
    
    dynamic var title: String = ""              // タイトル
    dynamic var url: String = ""                // 保存先
    dynamic var volume: Double = 1.0            // ボリューム
    dynamic var durationTime: Double = 0.0      // 再生時間
    dynamic var delayTime: Double = 0.0         // 遅延時間
}


class SoundBox: Object {
    
    //
    dynamic var id: Int = 0                     // インデックス
    dynamic var create_at = NSDate()            // 作成日
    dynamic var update_at = NSDate()            // 更新日
    
    // MediaDataの保存するデータ群
    dynamic var title: String = ""              // サウンドのタイトル
    dynamic var play_time: Double = 0.0         // 再生時間
    dynamic var save_path: String = ""          // 保存先のパス
    
    // このアプリのオリジナル要素
    dynamic var favorite_star: Int = 0          // お気に入り0 -- 5の6段階評価
    dynamic var delete_flag: Bool = false       // 論理削除フラグ
    dynamic var tap_count: Int = 0              // タップされた回数
    let categories = List<SoundCategory>()      // サウンドのカテゴリー
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

/*
 今後の追加予定
 - 音の加工
 - SoundBox 対 UserEditSound のリレーショナル・データベースの作成
 */


// https://realm.io/jp/docs/swift/latest/#section-6
class SoundCategory: Object {
    dynamic var category: String = ""
    let sound = LinkingObjects(fromType: SoundBox.self, property: "categories")
}





