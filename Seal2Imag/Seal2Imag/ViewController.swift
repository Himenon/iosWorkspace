//
//  ViewController.swift
//  Seal2Imag
//
//  Created by Himeno Kosei on 2017/01/03.
//  Copyright © 2017年 Kosei Himeno. All rights reserved.
//

import Cocoa
import ImageIO

class SielViewController: NSViewController, NSApplicationDelegate {
    
    @IBOutlet weak var thumbnail: NSImageView!
    @IBOutlet weak var referenceURL: NSTextField!
    @IBOutlet weak var imageInfoView: NSTextView!
    @IBOutlet weak var repImage: NSImageView!
    
    @IBOutlet weak var CopyRight: NSButton!
    @IBOutlet weak var DateCreated: NSButton!
    @IBOutlet weak var TimeCreated: NSButton!
    
    @IBOutlet weak var fontPopUpButton: NSPopUpButton!
    
    var checkBoxArray: [NSButton] = []
    
    enum IPTCmeta: String {
        case CopyrightNotice
        case DateCreated
        case TimeCreated
    }
    
    var IPTC: [IPTCmeta: Bool] = [
        .CopyrightNotice: false,
            .DateCreated: false,
            .TimeCreated: false
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBoxArray.append(CopyRight)
        checkBoxArray.append(DateCreated)
        checkBoxArray.append(TimeCreated)
        
        fontPopUpButton.removeAllItems()
        
        for fontName in NSFontManager.shared().availableFonts {
            let displayFont: NSFont = NSFont(name: fontName, size: 14)!
            let attributes = NSAttributedString(string: fontName, attributes: [
                NSFontAttributeName : displayFont
                ])
            
            let menuItem = NSMenuItem()
            menuItem.title = String(fontName)
            menuItem.attributedTitle = attributes
            fontPopUpButton.menu?.addItem(menuItem)
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func getURLandImageInfo(_ sender: Any) {
        referenceURL.stringValue = browseImageFile()!
        thumbnail.image = NSImage(contentsOfFile: referenceURL.stringValue)
        let displayText = String(describing: getImageInfo(fileUrl: referenceURL.stringValue)!)
        imageInfoView.insertText(displayText, replacementRange: NSMakeRange(-1, 0))
    }
    
    
    @IBAction func fontSelect(_ sender: Any) {
    }
    
    @IBAction func sealText2Image(_ sender: Any) {
        var message: String = ""
        updateCheck()
        if let imageProperty = getImageInfo(fileUrl: referenceURL.stringValue) {
            for (key, val) in IPTC {
                if val {
                    let IPTC_property: NSDictionary = imageProperty.value(forKey: "{IPTC}")! as! NSDictionary
                    message += String(describing: IPTC_property.value(forKey: key.rawValue)!) + "\n"
                }
                
            }
            let img = sealText(image: thumbnail.image!, insertText: message)
            repImage.image = img
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let accessoryView = NSView(frame: CGRect(x: 0, y: 0, width: 270, height: 50))
        let popup = NSPopUpButton(frame: CGRect(x: 130, y: 10, width: 120, height: 25))
        let label = NSTextField(frame: CGRect(x: 20, y: 15, width: 100, height: 18))
        let savePanel = NSSavePanel()
        
        popup.addItems(withTitles: ["png", "jpg", "gif"])
        
        label.stringValue = "拡張子 : "
        label.alignment = NSTextAlignment.right
        label.isBordered = false
        label.isSelectable = false
        label.isEditable = false
        label.backgroundColor = NSColor.clear
        
        // アクセサリービューに追加
        accessoryView.addSubview(popup)
        accessoryView.addSubview(label)
        
        // 保存可能なファイル形式を表示
        savePanel.allowedFileTypes = ["png", "jpg", "gif"]
        savePanel.accessoryView = accessoryView
        
        savePanel.beginSheetModal(for: self.view.window!) { (num: Int) -> Void in
            if (num == NSModalResponseOK) {
                print("保存を実行します")
//                print(savePanel.url!)
//                print(popup.selectedItem?.title)
                let rep = NSBitmapImageRep(cgImage: (self.repImage.image?.toCGImage)!)
                let imgData = rep.representation(using: .JPEG, properties: [:])!

                do {
                    try imgData.write(to: savePanel.url!)
                } catch {
                    NSLog("保存に失敗しました。")
                }
                
                
            } else {
                print("CANCEL")
            }
        }
        
        
//        let saveImage = repImage.image
    }
    
    @IBAction func selectFont(_ sender: Any) {
        let panel = NSFontPanel()
        let fm = NSFontManager.shared()
        fm.orderFrontFontPanel(panel)
    }
    
    func updateCheck() {
        for btn in checkBoxArray {
            let checkState = Bool(btn.state as NSNumber)
            let id = btn.identifier!
            let kkey = SielViewController.IPTCmeta(rawValue: id)
            IPTC.updateValue(checkState, forKey: kkey!)
        }
    }
    
    override func changeFont(_ sender: Any?) {
        print("CHANGE !!")
    }
    
    // https://denbeke.be/blog/programming/swift-open-file-dialog-with-nsopenpanel/
    func browseImageFile() -> String? {
        let dialog = NSOpenPanel();
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes        = ["png", "jpg", "jpeg"]
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                
                return path
            }
        }
        
        return nil
    }
    
    func getImageInfo(fileUrl: String) -> NSDictionary? {
        let url: NSURL = NSURL(fileURLWithPath: fileUrl)
        let imageSource = CGImageSourceCreateWithURL(url, nil)
        let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource!, 0, nil)! as NSDictionary
        
        if (imageProperties.value(forKey: "{Exif}") != nil) {
            
            return imageProperties
        }
        
        return nil
    }

    func sealText(image: NSImage, insertText: String) -> NSImage {
        // http://stackoverflow.com/questions/27790315/macos-programmatically-add-some-text-to-an-image
        let f2 = NSImage(size: image.size, flipped: true, drawingHandler:{ (dstRect: NSRect) -> Bool in
            image.draw(in: dstRect)
            // どこをみればいい？
            // http://tea-leaves.jp/home/ja/article/1374929836
            let fontName: String = String(describing: self.fontPopUpButton.selectedItem!.title)
            let displayFont: NSFont = NSFont(name: fontName, size: 32)!

            let attributes: NSDictionary = [
                NSFontAttributeName: displayFont,//NSFont.boldSystemFont(ofSize: 32),
                NSForegroundColorAttributeName: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            ]
            (insertText as NSString).draw(at: NSMakePoint(50, 50), withAttributes: attributes as? [String : Any])
            return true
        })
        
        let rep = NSBitmapImageRep(cgImage: f2.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        let image_data: Data = rep.representation(using: NSJPEGFileType, properties: [:])!
        return NSImage(data: image_data)!
    }
}


// http://qiita.com/HaNoHito/items/2fe95aba853f9cedcd3e
extension NSImage {
    var toCGImage: CGImage {
        var imageRect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        #if swift(>=3.0)
            guard let image =  cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else {
                abort()
            }
        #else
            guard let image = CGImageForProposedRect(&imageRect, context: nil, hints: nil) else {
            abort()
            }
        #endif
        return image
    }
}

