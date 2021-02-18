//
//  Users.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 17/02/21.
//

import UIKit


// MARK: - Users
@objcMembers public class Users: NSObject, Codable
{
    public var username: String?
    public var jid: String?
    public var isOnline: OnlineType?

    enum CodingKeys: String, CodingKey
    {
        case jid = "id"
        case username = "name"
        case isOnline = "isOnline"
    }
}
