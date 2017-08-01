//
//  DataViewController.swift
//  GPSDrawApp-iOS
//
//  Created by Himeno Kosei on 2016/09/24.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Foundation
import UIKit

class DataView: UIViewController {
    let canvas_url = NSURL(string: "https://k4zzk:ftyy7304@app3.hackerslog.net")
    @IBOutlet weak var WebCanvas: UIWebView!
    
    override func viewDidLoad() {
        let request = URLRequest(url: canvas_url! as URL)
        WebCanvas.loadRequest(request)
    }
}

