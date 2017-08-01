//
//  ViewController.swift
//  GPSDrawApp-iOS
//
//  Created by Himeno Kosei on 2016/09/24.
//  Copyright © 2016年 Kosei Himeno. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var email_textfiled: UITextField!
    @IBOutlet weak var password_textfield: UITextField!
    @IBOutlet weak var status_label: UILabel!
    let userController = UserController.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        email_textfiled.delegate = self
        password_textfield.delegate = self
        print("VIEWDIDLOAD")
        if let last_user: User = userController.get_last_user() {
            status_label.text = "すでにユーザー存在します。"
            email_textfiled.isEnabled = false
            password_textfield.isEnabled = false
            
            email_textfiled.text = last_user.email
            password_textfield.text = last_user.password
            
//            userController.sign_in()
        } else {
            email_textfiled.text = ""
            password_textfield.text = ""
            status_label.text = "新しくユーザーを作る必要があります。"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sign_up(_ sender: AnyObject) {
        let password: String = password_textfield.text!
        let email: String = email_textfiled.text!
        userController.email = email
        userController.password = password
        userController.sign_up()
    }
    
    @IBAction func cleanButton(_ sender: AnyObject) {
        userController.clean_database()
        email_textfiled.isEnabled = true
        password_textfield.isEnabled = true
        
        email_textfiled.text = ""
        password_textfield.text = ""
        
        status_label.text = "ローカルデータを削除しました。新しくユーザーを作る必要があります。"
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }

    @IBAction func unwindToTop(segue: UIStoryboardSegue) {
    }
}

