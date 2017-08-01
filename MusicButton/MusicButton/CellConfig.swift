//
//  TouchCell.swift
//  MusicButton
//
//  Created by Himeno Kosei on 2016/06/20.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import UIKit
import Foundation

class SoundBtnCell: UICollectionViewCell {
    @IBOutlet var instrumentImage: UIImageView!
    @IBOutlet var cellNumber:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func updateFrame() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
        
        self.instrumentImage.frame.size.height = self.frame.height / 2 * 3
        self.instrumentImage.frame.size.width = self.frame.width * 2 / 3
    }
}

class SoundBoxTableCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var play_time: UILabel!
    @IBOutlet var category: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}