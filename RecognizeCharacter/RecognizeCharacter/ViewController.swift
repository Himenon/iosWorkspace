//
//  ViewController.swift
//  RecognizeCharacter
//
//  Created by Himeno Kosei on 2016/01/18.
//  Copyright © 2016年 Himeno Kosei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, G8TesseractDelegate {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var imageView: UIImageView = UIImageView()
    var label: UILabel = UILabel()
    
    let image = UIImage(named: "aaa.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = UIImage(named: "aaa.png")
        
        label.frame = CGRectMake(0, 300,  self.view.frame.size.width, 200)
        label.lineBreakMode = NSLineBreakMode.ByCharWrapping
        label.numberOfLines = 0
        label.text = "Analyzing..."
        
        self.view.addSubview(imageView)
        self.view.addSubview(label)
        
        analyze()
    }
    
    func analyze() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            var tesseract = G8Tesseract(language: "jpn")
            tesseract.delegate = self
            tesseract.image = self.image
            tesseract.recognize()
            
            self.label.text = tesseract.recognizedText
            
            print(tesseract.recognizedText)
        })
    }
    
    func shouldCancelImageRecognitionForTesseract(tesseract: G8Tesseract!) -> Bool {
        return false; // return true if you need to interrupt tesseract before it finishes
    }

}

