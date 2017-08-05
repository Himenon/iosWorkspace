// 写真のEXIF情報を入手するサンプル

//http://stackoverflow.com/questions/31888319/swift-accesing-exif-dictionary

import UIKit
import ImageIO

let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

let url = NSURL(string: "https://d33wubrfki0l68.cloudfront.net/a3e0cf998e731b15a107c6735621a51b082c0310/b4b2a/assets/images/member/2016/syugo.jpg")

/*
 var url:NSURL = NSURL(fileURLWithPath: fileUrl)!
 //exif情報取得
 imageRef:CGImageSourceRef = CGImageSourceCreateWithURL(url, nil)
 imageDict:NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageRef, 0, nil)
  
 var exif: AnyObject? = imageDict.objectForKey(kCGImagePropertyExifDictionary)
 var date: AnyObject? = exif?.objectForKey(kCGImagePropertyExifDateTimeOriginal)
*/

//NSURL(fileURLWithPath: <#T##String#>)
let local_url = NSURL(fileURLWithPath: "file:///Users/himepro/Pictures/%E5%A3%81%E7%B4%99/IMG_1581.jpg")
//let data = NSData(contentsOfFile: (local_url.absoluteString)!)
//let data = NSData(url: local_url)
let data = NSData(contentsOf: local_url as URL)

//NSData(contentsOfFile: <#T##String#>)
//local_url?.absoluteString
//let cdata = CFDataCreate(nil, data?.bytes, data?.length)
// CFData
// http://stackoverflow.com/questions/27838628/how-to-create-a-cgimagesourceref-from-image-raw-data
// CGImageSource
let imageSource = CGImageSourceCreateWithURL(url!, nil)
//let imageSource = CGImageSourceCreateWithURL(Bundle.main.resourcePath + local_url!, nil)
//let imageSource = CGImageSourceCreateWithData(data!, nil)

// CFDictionary: Dictionaryが返り値
let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil)! as NSDictionary;

if (imageProperties.value(forKey: "{Exif}") != nil) {
    let exifDict = imageProperties.value(forKey: "{Exif}") as! NSDictionary;
    let dateTimeOriginal = exifDict.value(forKey: "DateTimeOriginal") as! NSString;
    
    print ("DateTimeOriginal: \(dateTimeOriginal)");
    
    let lensMake = exifDict.value(forKey: "LensMake");
    print ("LensMake: \(lensMake)");
}

for (key, val) in imageProperties {
    print(key, val)
}
