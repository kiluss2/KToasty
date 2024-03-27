//
//  ViewController.swift
//  KToasty
//
//  Created by Lê Văn Sơn on 11/20/2023.
//  Copyright (c) 2023 Lê Văn Sơn. All rights reserved.
//

import UIKit
import KToasty

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let toast = Toasty(message: "Hi world!", sender: self)
        let toast = Toasty(messageAttribuleString: initAttributeString(), sender: self)
        toast.show()
    }
    
    func initAttributeString() -> NSMutableAttributedString {
        let fullString = NSMutableAttributedString(string:"To start messaging contacts, tap ")
        
        // create our NSTextAttachment
        let imageAttachment = NSTextAttachment()
        if #available(iOS 13.0, *) {
            imageAttachment.image = UIImage(systemName: "pencil.tip.crop.circle")
        } else {
            // Fallback on earlier versions
        }
        imageAttachment.bounds = CGRect(x: 0, y: -8, width: 25, height: 25)
        
        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        // add the NSTextAttachment wrapper to our full string, then add some more text.
        
        fullString.append(imageString)
        fullString.append(NSAttributedString(string:" at the right bottom of your screen"))
        return fullString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

