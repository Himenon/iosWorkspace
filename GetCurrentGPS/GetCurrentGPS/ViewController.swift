//
//  ViewController.swift
//  GetCurrentGPS
//
//  Created by Himeno Kosei on 2016/09/17.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var lm: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    @IBOutlet var latitudeLabel: UILabel!
    @IBOutlet var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lm = CLLocationManager()
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        lm.delegate = self
        lm.pausesLocationUpdatesAutomatically = false
        lm.activityType = CLActivityType.fitness
        lm.allowsBackgroundLocationUpdates = true
    }

    @IBAction func SetupGPS(_ sender: UIButton) {
        lm.requestAlwaysAuthorization()
        lm.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let newLocation = locations.last
        latitude = newLocation?.coordinate.latitude
        longitude = newLocation?.coordinate.longitude
        
        NSLog("x = \(longitude!), y = \(latitude!)")
        updateLabel()
    }
    
    func updateLabel() {
        latitudeLabel.text = String(latitude)
        longitudeLabel.text = String(longitude)
    }
    
    // --------------------------- 位置情報のステータス ---------------------------
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        NSLog("位置情報の取得を停止しました。")
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        NSLog("位置情報の後進を再開しました。")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("位置情報の取得に失敗しました。")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

