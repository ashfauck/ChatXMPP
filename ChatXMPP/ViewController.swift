//
//  ViewController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 16/02/21.
//

import UIKit
import XMPPFramework
import xmpp_messenger_ios

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        OneMessage.sharedInstance.delegate = self

        
        
    }


}

