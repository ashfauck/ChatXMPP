// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let fetchDeviceID = try? newJSONDecoder().decode(FetchDeviceID.self, from: jsonData)

import Foundation

// MARK: - FetchDeviceID
@objcMembers public class FetchIQ: NSObject, Codable
{
    public var iq: FetchDeviceID?

    enum CodingKeys: String, CodingKey
    {
        case iq = "pubsub"
    }
}


// MARK: - FetchDeviceID
@objcMembers public class FetchDeviceID: NSObject, Codable
{
    public var deviceIdItem: DeviceIdItems?

    enum CodingKeys: String, CodingKey
    {
        case deviceIdItem = "items"
    }
}

// MARK: - Items
@objcMembers public class DeviceIdItems: NSObject, Codable
{
    public var deviceId: DeviceId?

    enum CodingKeys: String, CodingKey
    {
        case deviceId = "item"
    }
}

// MARK: - Item
@objcMembers public class DeviceId: NSObject, Codable
{
    public var id: String?
    public var device: Device?

    enum CodingKeys: String, CodingKey
    {
        case id = "@id"
        case device = "list"
    }
}

// MARK: - List
@objcMembers public class Device: NSObject, Codable
{
    public var id: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "device"
    }
}
