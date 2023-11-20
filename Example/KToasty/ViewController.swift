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
        
        let toast = Toasty(message: "Hello World!", sender: self)
        toast.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

