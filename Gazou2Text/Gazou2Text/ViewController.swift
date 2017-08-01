//
//  ViewController.swift
//  Gazou2Text
//
//  Created by Himeno Kosei on 2017/01/14.
//  Copyright © 2017年 Kosei Himeno. All rights reserved.
//

import UIKit
import Photos
import ImageIO

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraImageView: UIImageView!
    
    var originalImage: UIImage!
    var editImage: UIImage!
    var meta:NSDictionary? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pickUpImage(_ sender: Any) {
        // Info.plistに下記の記述必要
        // Privacy - Photo Library Usage Description
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
            // func imagePickerController へ移動
        }
    }
    
    
    @IBAction func writeDate(_ sender: Any) {
        print("===== write Date =====")
        if let tiff: NSDictionary = meta?["{TIFF}"] as! NSDictionary? {
            print(tiff)
            let createDateText = tiff["DateTime"]
            editImage = drawText(image: originalImage, inputText: createDateText as! String)
            cameraImageView.image = editImage
        } else {
            print("TIFFを読み込めませんでした．")
        }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        // http://joyplot.com/documents/2016/08/19/swift%E3%81%A7imageview%E3%81%AE%E7%94%BB%E5%83%8F%E3%82%92%E3%82%AB%E3%83%A1%E3%83%A9%E3%83%AD%E3%83%BC%E3%83%AB%E3%81%AB%E4%BF%9D%E5%AD%98%E3%81%99%E3%82%8B/
        UIImageWriteToSavedPhotosAlbum(editImage, self, nil, nil)
        print("画像を保存しました")
        
        // http://qiita.com/fishpilot272/items/b76e62eb82fc8d788da5
        let alert: UIAlertController = UIAlertController(title: "完了", message: "画像の保存に成功しました．", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("保存に成功しました．")
        })
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        cameraImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        originalImage = cameraImageView.image
        dismiss(animated: true, completion: nil)
        
        // 以下は写真情報を取得する
        // http://titirobo-develop.hatenablog.jp/entry/2016/10/20/143111
        
        let assetUrl:NSURL = (info[UIImagePickerControllerReferenceURL] as! NSURL?)!
        let url = NSURL(string: (assetUrl.description))!
        let result = PHAsset.fetchAssets(withALAssetURLs: [url as URL], options: nil)
        let asset:PHAsset = result.firstObject! as PHAsset
        let editOptions = PHContentEditingInputRequestOptions()
        editOptions.isNetworkAccessAllowed = true
        
        asset.requestContentEditingInput(with: editOptions, completionHandler: { (contentEditingInput, _) -> Void in
            let url = contentEditingInput?.fullSizeImageURL
            let inputImage:CIImage = CoreImage.CIImage(contentsOf: url!)!
            
            //self.meta = inputImage.properties["{Exif}"] as? NSDictionary
            self.meta = inputImage.properties as NSDictionary?
            print(inputImage.properties)
            
            // exif情報の取得
            // let exif:NSDictionary = self.meta!["{Exif}"] as! NSDictionary
        })
    }
    
    func drawText(image :UIImage, inputText: String) ->UIImage
    {
        let text = inputText
        
        let font = UIFont.boldSystemFont(ofSize: 32)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        UIGraphicsBeginImageContext(image.size);
        image.draw(in: imageRect)
        
        let textRect  = CGRect(x: 5, y: 5, width: image.size.width - 5, height: image.size.height - 5)
        let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        // フォントサイズなどを設定
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: UIColor.white,
            NSParagraphStyleAttributeName: textStyle
        ]
        text.draw(in: textRect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}

