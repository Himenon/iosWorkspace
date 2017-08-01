//
//  MusicPlayList.swift
//  GetMusicLibrary
//
//  Created by Himeno Kosei on 2016/06/23.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Foundation
import RealmSwift

class MusicPlayList: Object {
    dynamic var id: Int = 0
    dynamic var add_date_at = NSDate()
    dynamic var update_at = NSDate()
    dynamic var alubm_title: String = ""
    dynamic var alubm_url: String = ""
    dynamic var alubm_thumbnail: NSData? = NSData()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
