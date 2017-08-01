//
//  GPSViewController.swift
//  GPSDrawApp-iOS
//
//  Created by Himeno Kosei on 2016/09/24.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import RealmSwift

class GPSViewController: UIViewController, CLLocationManagerDelegate {
    
    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    var userController = UserController.sharedManager
    
    let upload_time_interval: Int = 10 // second
    var upload_count_timer: Int = 0     // second
    var timer: Timer!
    
    @IBOutlet weak var WebCanvas: UIWebView!
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    
    let canvas_url = NSURL(string: "https://k4zzk:ftyy7304@app3.hackerslog.net")
    
    override func viewDidLoad() {
        print("GPS VIEW CONTROLLER")
        super.viewDidLoad()
        
        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        lm.delegate = self
        lm.pausesLocationUpdatesAutomatically = false
        lm.activityType = CLActivityType.fitness
        lm.allowsBackgroundLocationUpdates = true
        
        let request = URLRequest(url: canvas_url! as URL)
        WebCanvas.loadRequest(request)
        
    }
    
    @IBAction func StartGPS(_ sender: UIButton) {
        NSLog("-------------------------- Start GPS --------------------------")
        lm.requestAlwaysAuthorization()
        lm.startUpdatingLocation()
        NSLog("-------------------------- Start Timer --------------------------")
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GPSViewController.timer_count_up), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func timer_count_up() {
        upload_count_timer += 1
    }
    
    @IBAction func StopGPS(_ snder: UIButton) {
        NSLog("Stop GPS")
        lm.stopUpdatingLocation()
        if (timer != nil && timer.isValid) {
            timer.invalidate()
        }
    }
    
    @IBAction func BackView(segue: UIStoryboardSegue) {
        print("画面を戻します。")
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("-------- location Manager ---------")
        let newLocation = locations.last
        latitude = newLocation?.coordinate.latitude
        longitude = newLocation?.coordinate.longitude
        
        userController.set_geometry(longitude: Double(longitude), latitude: Double(latitude))
        
        if upload_count_timer > upload_time_interval {
            print("送信開始: 配列数: \(userController.geometry_array.count)")
            userController.post_geometry()
            upload_count_timer = 0
        }
        
        NSLog("x = \(longitude!), y = \(latitude!)")
        updateLabel()
        updateRoutes()
    }
    
    func updateLabel() {
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
    }
    
    func updateRoutes() {
        let route = Routes()
        route.add_point(lat: Double(latitude), lon: Double(longitude))
    }
    
    // --------------------------- 位置情報のステータス ---------------------------
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        NSLog("位置情報の取得を停止しました。")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        NSLog("位置情報の後進を再開しました。")
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

