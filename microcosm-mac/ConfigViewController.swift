//
//  ConfigViewController.swift
//  microcosm-mac
//
//  Created by Yuji Ogata on 2016/10/09.
//  Copyright © 2016年 Yuji Ogata. All rights reserved.
//

import Cocoa

class ConfigViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask.remove(.resizable)
    }
    

    
}
