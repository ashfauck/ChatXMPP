//
//  SignalStoreInMemoryStorage.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 16/03/21.
//

import UIKit
import SignalProtocolObjC

class SignalStoreInMemoryStorage: NSObject
{
    
    var identityKeyPair:SignalIdentityKeyPair?
    var localRegistrationId:UInt32?
    
    var sessionStore:[String:[NSNumber:Data]] = [:]
    var preKeyStore:[Int32:Data] = [:]
    var signedPreKeyStore:[Int32:Data] = [:]
    var identityKeyStore:[String:Data] = [:]
    var senderKeyStore:[String:Data] = [:]
    
    
    override init()
    {
        self.sessionStore = [:]
        self.preKeyStore = [:]
        self.signedPreKeyStore = [:]
        self.identityKeyStore = [:]
        self.senderKeyStore = [:]
    }
    

    

}

extension SignalStoreInMemoryStorage: SignalStore
{
    func deviceSessionRecordsForAddressName(addressName:String) -> [NSNumber:Data]?
    {
        return self.sessionStore[addressName]
    }
    
    func sessionRecord(for address: SignalAddress) -> Data?
    {
        return self.deviceSessionRecordsForAddressName(addressName: address.name)?[NSNumber(value: address.deviceId)]
    }
    
    func storeSessionRecord(_ recordData: Data, for address: SignalAddress) -> Bool
    {
        let dict = [NSNumber(value: address.deviceId) : recordData]
        self.sessionStore[address.name] = dict
        return true
    }
    
    func sessionRecordExists(for address: SignalAddress) -> Bool
    {
        if self.sessionRecordExists(for: address)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func deleteSessionRecord(for address: SignalAddress) -> Bool
    {
        var devices = self.deviceSessionRecordsForAddressName(addressName: address.name)

        devices?.removeValue(forKey: NSNumber(value: address.deviceId))
        
        return true
    }
    
    func allDeviceIds(forAddressName addressName: String) -> [NSNumber]
    {
        
        let deviceNumber = self.deviceSessionRecordsForAddressName(addressName: addressName)?.keys.map({ (number) -> NSNumber in
            return number
        })
        
        if let devices = deviceNumber
        {
            return devices
        }
        
        return []
    }
    
    func deleteAllSessions(forAddressName addressName: String) -> Int32
    {
        var sessionRecords = self.deviceSessionRecordsForAddressName(addressName: addressName)
        
        let count = Int32(sessionRecords?.count ?? 0)
        
        sessionRecords?.removeAll()
        
        return count
    }
    
    func loadPreKey(withId preKeyId: UInt32) -> Data?
    {
        return self.preKeyStore[Int32(preKeyId)]
    }
    
    func storePreKey(_ preKey: Data, preKeyId: UInt32) -> Bool
    {
        self.preKeyStore[Int32(preKeyId)] = preKey
        return true
    }
    
    func containsPreKey(withId preKeyId: UInt32) -> Bool
    {
        if (self.preKeyStore[Int32(preKeyId)] != nil)
        {
            return true
        }
        
        return false
    }
    
    func deletePreKey(withId preKeyId: UInt32) -> Bool
    {
        self.preKeyStore.removeValue(forKey: Int32(preKeyId))
        return true
    }
    
    func loadSignedPreKey(withId signedPreKeyId: UInt32) -> Data?
    {
        return self.signedPreKeyStore[Int32(signedPreKeyId)]
    }
    
    func storeSignedPreKey(_ signedPreKey: Data, signedPreKeyId: UInt32) -> Bool
    {
        self.signedPreKeyStore[Int32(signedPreKeyId)] = signedPreKey
        return true
    }
    
    func containsSignedPreKey(withId signedPreKeyId: UInt32) -> Bool
    {
        if (self.signedPreKeyStore[Int32(signedPreKeyId)] != nil)
        {
            return true
        }
        
        return false
    }
    
    func removeSignedPreKey(withId signedPreKeyId: UInt32) -> Bool
    {
        self.signedPreKeyStore.removeValue(forKey: Int32(signedPreKeyId))
        return true
    }
    
    func getIdentityKeyPair() -> SignalIdentityKeyPair
    {
        return self.identityKeyPair ?? SignalIdentityKeyPair()
    }
    
    func getLocalRegistrationId() -> UInt32
    {
        return UInt32(self.localRegistrationId ?? 0)
    }
    
    func saveIdentity(_ address: SignalAddress, identityKey: Data?) -> Bool
    {
        self.identityKeyStore[address.name] = identityKey
        return true
    }
    
    func isTrustedIdentity(_ address: SignalAddress, identityKey: Data) -> Bool
    {
        let data = self.identityKeyStore[address.name]
        
        if data == nil
        {
            return true
        }
        
        if data == identityKey
        {
            return true
        }
        
        return false
    }
    
    func keyForAddress(address:SignalAddress, groupId: String) -> String
    {
        return "\(address.name)\(address.deviceId)\(groupId)"
    }
    
    func storeSenderKey(_ senderKey: Data, address: SignalAddress, groupId: String) -> Bool
    {
        let key = self.keyForAddress(address: address, groupId: groupId)
        self.senderKeyStore[key] = senderKey
        return true
    }
    
    func loadSenderKey(for address: SignalAddress, groupId: String) -> Data?
    {
        let key = self.keyForAddress(address: address, groupId: groupId)
        return self.senderKeyStore[key]
    }
    
}
