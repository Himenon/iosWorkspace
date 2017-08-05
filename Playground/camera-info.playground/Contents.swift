//: Playground - noun: a place where people can play

import Cocoa
import ImageIO

var str = "Hello, playground"

let fileUrl = "https://d33wubrfki0l68.cloudfront.net/a3e0cf998e731b15a107c6735621a51b082c0310/b4b2a/assets/images/member/2016/syugo.jpg"

var url:NSURL = NSURL(fileURLWithPath: fileUrl)
//exif情報取得
var imageRef: CGImageSource = CGImageSourceCreateWithURL(url, nil)!
var imageDict: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageRef, 0, nil)!

var exif: AnyObject? = imageDict.object(forKey: kCGImagePropertyExifDictionary) as AnyObject?
//var date: AnyObject? = exif?.object(kCGImagePropertyExifDateTimeOriginal)
