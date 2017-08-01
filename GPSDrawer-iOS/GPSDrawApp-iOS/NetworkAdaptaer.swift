//
//  NetworkAdaptaer.swift
//  GPSDrawApp-iOS
//
//  Created by Himeno Kosei on 2016/09/25.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import Foundation
import RealmSwift

class UserController {
    let sign_in_url = "https://k4zzk:ftyy7304@app3.hackerslog.net/api/v1/sign_in"
    let sign_up_url = "https://k4zzk:ftyy7304@app3.hackerslog.net/api/v1/sign_up"
    let geometry_url = "https://k4zzk:ftyy7304@app3.hackerslog.net/api/v2/geometries"
    var password: String = ""
    var email: String = ""
    var access_token: String?
    var geometry_array: NSMutableArray = []
    var data_exist_flag = false
    
    
    static let sharedManager = UserController()
    private init() {
    }
    
    func sign_up() {
        let realm = try! Realm()
        NSLog("-------------------------- SIGN UP --------------------------")
        let user = realm.objects(User.self).last
        
        if ((user?.access_token) != nil) {
            // アクセストークンがある場合
            access_token = (user?.access_token)! as String
            print("アクセストークンを使用してログインします。: \(access_token)")
        } else {
            // アクセストークンがない場合
            if user != nil {
                // ユーザーを新規作成する場合
                try! realm.write {
                    user?.password = password
                    user?.email = email
                }
            } else {
                // すでにユーザーがある場合
               self.add_user()
            }
            self.sign_up_first()
        }
        
    }
    
    func clean_database() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func is_exist() -> Bool {
        let realm = try! Realm()
        if realm.objects(User.self).count > 0 {
            print("データが存在します。")
            data_exist_flag = true
            return true
        } else {
            print("データが存在しません。")
            data_exist_flag = false
            return false
        }
    }
    
    func get_last_user() -> User? {
        NSLog("-------------------------- GET LAST USER --------------------------")
        if self.is_exist() {
            let realm = try! Realm()
            let data_user = realm.objects(User.self).last!
            let last_user = User()
            last_user.email = data_user.email
            last_user.password = data_user.password
            last_user.access_token = data_user.access_token
        return last_user
        } else {
            return nil
        }
    }
    
    func sign_in() {
        // Todo: Validation CHeck
        print("=========== START SIGN IN ===========")
        let realm = try! Realm()
        let user = realm.objects(User.self).last!
        
        let request = NSMutableURLRequest(url: NSURL(string: geometry_url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let post_params = [
            "user": [
                "email": user.email,
                "password": user.password
            ]
        ]
        
        print("------------------------------------POSTDATA------------------------------------")
        print(post_params)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: post_params, options: .prettyPrinted)
        } catch {
            print("ERROR")
        }
        
        let task: Any = URLSession.shared.dataTask(with: request as URLRequest) {data, res, error in
            if (error == nil) {
                // サーバーからの返答
                let sjson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let djson = sjson.data(using: .utf8)
                if let parsedData = try? JSONSerialization.jsonObject(with: djson!) as! [String:Any] {
                    print(parsedData)
                    if let get_token = parsedData["access_token"] {
                        print("Access Token = \(get_token)")
                    }
                }
            } else {
                print(error)
            }
        }
        
        (task as AnyObject).resume()
    }
    
    func post_geometry() {
        NSLog("-------------------------- post Geometry --------------------------")
        /* サーバーに座標データを送信するメソッド */
        let request = NSMutableURLRequest(url: NSURL(string: geometry_url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.access_token!, forHTTPHeaderField: "K-Authorization")
        
        let post_params: [String: NSMutableArray] = ["geometries": geometry_array]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: post_params, options: .prettyPrinted)
        } catch {
            print("ERROR")
        }
        
        let task: Any = URLSession.shared.dataTask(with: request as URLRequest) {data, res, error in
            if (error == nil) {
                // サーバーからの返答
                print("データ送信に成功しました。")
                let sjson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let djson = sjson.data(using: .utf8)
                if let parsedData = try? JSONSerialization.jsonObject(with: djson!) as! [String:Any] {
                    print("サーバーからの応答です。: \(parsedData)")
                }
            } else {
                print(error)
            }
        }
        
        geometry_array.removeAllObjects()
        
        (task as AnyObject).resume()
    }
    
    func set_geometry(longitude: Double, latitude: Double) {
        geometry_array.add(
            [
                "longitude": longitude,
                "latitude": latitude
            ]
        )
        print("[\(geometry_array.count)]Geometry Array")
    }
    
    func sign_up_first() {
        print("========= 新規サインアップを行います。 ==========")
        // アカウントが存在・非存在で共通
        let realm = try! Realm()
        let user = realm.objects(User.self).last!
        
        let request = NSMutableURLRequest(url: NSURL(string: sign_up_url)! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // POSTデータの生成
        let post_params = [
            "user": [
                "email": user.email,
                "password": user.password
            ]
        ]
        
        
        // JSONに変更
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: post_params, options: .prettyPrinted)
        } catch {
            print("ERROR")
        }
        
        let task: Any = URLSession.shared.dataTask(with: request as URLRequest) {data, res, error in
            if (error == nil) {
                // サーバーからの返答
                let sjson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                let djson = sjson.data(using: .utf8)
                if let parsedData = try? JSONSerialization.jsonObject(with: djson!) as! [String:Any] {
                    if let get_access_token = parsedData["access_token"] {
                        print("アクセストークン: \(get_access_token)")
                        // アクセストークンを取得後更新
                        self.access_token = get_access_token as? String
                        self.update_last_user()
                    } else {
                        print("アクセストークンが正しく取得できませんでした。")
                        print(parsedData["error"])
                    }
                    
                }
            } else {
                print(error)
            }
        }
        
        (task as AnyObject).resume()
        print("========= SIGN END ==========")
    }
    
    func add_user() {
        NSLog("-------------------------- Add USER --------------------------")
        let realm = try! Realm()
        let last_user_count: Int = realm.objects(User.self).count
        print("Last User Count = \(last_user_count)")
        let user = User()
        user.id = self.data_exist_flag ? last_user_count + 1 : 0
        user.password = password
        user.email = email
        user.access_token = nil
        try! realm.write {
            realm.add(user)
        }
    }

    
    func update_last_user() {
        NSLog("-------------------------- Update Last User --------------------------")
        if self.is_exist() {
            let realm = try! Realm()
            print("アクセストークンを保存します。")
            let user = realm.objects(User.self).last
            
            try! realm.write {
                user?.access_token = access_token
            }
        }
        print("アクセストークンの保存が完了しました")
    }
}
