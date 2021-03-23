//
//  UserDefaults.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 19/03/21.
//

import Foundation


var currentDeviceId:NSNumber?
{
    get {
        return UserDefaults.standard.object(forKey: "currentDeviceId") as? NSNumber
    }
    
    set {
        UserDefaults.standard.set(newValue, forKey: "currentDeviceId")
    }
}
