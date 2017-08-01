//
//  Model.swift
//  GPSDrawApp-iOS
//
//  Created by Himeno Kosei on 2016/09/24.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    dynamic var id: Int = 0
    dynamic var email: String = ""
    dynamic var password: String = ""
    dynamic var access_token: String?
    override static func primaryKey() -> String? {
        return "id"
    }
    
    let pass_routes = List<Routes>()
//    
//    func sign_up(password: String, email: String) {
//        let realm = try! Realm()
//        let user = realm.objects(User.self).first
//        
//        if ((user?.access_token) != nil) {
//            print("アクセストークンを使用してログインします。")
//            print(user?.access_token)
//        } else {
//            if user != nil {
//                try! realm.write {
//                    user?.password = password
//                    user?.email = email
//                }
//            } else {
//                update_fund_params(email: email, password: password)
//            }
//            
//            
//            post_sign_up()
//        }
//    
//        
//    }
//    
//    func update_fund_params(email: String, password: String) {
//        DispatchQueue(label: "background").async {
//            let realm = try! Realm()
//            let new_user = User()
//            new_user.id = 1
//            new_user.password = password
//            new_user.email = email
//            try! realm.write {
//                realm.add(new_user)
//            }
//        }
//    }
//    
//    func update_params(t_access_token: String) {
//        DispatchQueue(label: "background").async {
//            let realm = try! Realm()
//            let user = realm.objects(User.self).filter("id == 1").first
//            try! realm.write {
//                user!.access_token = t_access_token
//            }
//        }
//    }
//    
//    func post_sign_up() {
//        print("========= SIGN UP ==========")
//        let realm = try! Realm()
//        let user = realm.objects(User.self).first!
//        let serverURL = "https://k4zzk:ftyy7304@app3.hackerslog.net/api/v1/sign_up"
//        let request = NSMutableURLRequest(url: NSURL(string: serverURL)! as URL)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        
//        
//        let post_params = [
//            "user": [
//                "email": user.email,
//                "password": user.password
//            ]
//        ]
//        
//        print("ポスト前のデータ, 現在保存中のデータ数: \(realm.objects(User.self).count)")
//        print("email: \(user.email), password: \(user.password)")
//        print(post_params)
//        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: post_params, options: .prettyPrinted)
//        } catch {
//            print("ERROR")
//        }
//        
//        let task: Any = URLSession.shared.dataTask(with: request as URLRequest) {data, res, error in
//            
////            
//            if (error == nil) {
//                print("--------- Get JSON Data ---------")
//                let sjson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
//                let djson = sjson.data(using: .utf8)
//                if let parsedData = try? JSONSerialization.jsonObject(with: djson!) as! [String:Any] {
//                    if let get_access_token = parsedData["access_token"] {
//                        print("アクセストークン: \(get_access_token)")
//                        self.update_params(t_access_token: get_access_token as! String)
//                        print("アクセストークンの保存が完了しました")
//                    } else {
//                        print("アクセストークンが正しく取得できませんでした。")
//                        print(parsedData["error"])
//                    }
//                    
//                }
//            } else {
//                print(error)
//            }
//        }
//        
//        (task as AnyObject).resume()
//        print("========= SIGN END ==========")
//    }
}

class Routes: Object {
    dynamic var id: Int = 0
    dynamic var date: Date = Date()
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func add_point(lat: Double, lon: Double) {
        let realm = try! Realm()
        let route = Routes()
        let last_id = realm.objects(Routes.self).count
        route.id = last_id + 1
        route.latitude = lat
        route.longitude = lon
        
        print("Count: \(last_id)")
        
        try! realm.write {
            realm.add(route)
        }
    }

    func get_all() {
        
    }
}



