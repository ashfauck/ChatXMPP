//
//  LoginViewController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import UIKit
import SignalProtocolObjC
import XMPPFramework
import XMLParsing

class LoginViewController: UIViewController {

    
    // MARK: - Properties
    
    var omemoModule:OMEMOModule?
    var controller:XMPPController?
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        let stream = XMPPController.shared

        self.updateXMPP()
        
//        self.encryption()
        
//        self.emailTxtFld.text = "@fly-qa19.mirrorfly.com/Mobile-1602F24AF37F4293832E54AAF83A33EF"
//        self.passwordTxtFld.text = "UbmLPulce0XL8yx"
//
        controller = try! XMPPController(hostName: "fly-qa19.mirrorfly.com", userJIDString: "919894562544@fly-qa19.mirrorfly.com", hostPort: 5226, password: "UW6r4c6GlndTcJl")
//        controller = try! XMPPController(hostName: "stun.joiint.com", userJIDString: "joiint-0@stun.joiint.com", hostPort: 5222, password: "joiint")

        controller?.xmppStream.addDelegate(self, delegateQueue: .main)
        controller?.connect()
    }
    
    // MARK: - Set up
    
    func updateXMPP()
    {
        
//        XMPPController.shared.didUpdateLoading = { (success) in
//
//            DispatchQueue.main.async {
//                if success
//                {
//                    self.view.showLoadingHUD()
//                }
//                else
//                {
//                    self.view.hideLoadingHUD()
//                }
//            }
//        }
//
//        XMPPController.shared.loginSuccess = { () in
//
//            DispatchQueue.main.async
//            {
////                if let vc = self.storyboard?.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController
////                {
////                    self.navigationController?.pushViewController(vc, animated: true)
////                }
//            }
//        }
//
//        XMPPController.shared.alertMessage = { (message) in
//
//            DispatchQueue.main.async {
//                self.showAlert(withTitle: message, message: nil)
//            }
//
//        }
    }
    
    // MARK: - IBActions
    
    @IBAction func loginBtnAction(_ sender: UIButton)
    {
        
        self.view.endEditing(true)
        
        guard let jid = self.emailTxtFld.text, jid.count > 0 else {
            self.showAlert(withTitle: "Please enter JID", message: nil)
            return
        }
        
        guard let password = self.passwordTxtFld.text, password.count > 0  else {
            self.showAlert(withTitle: "Please enter password", message: nil)
            return
        }
        
        
//        XMPPController.shared.connectStream(jid: jid, password: password)
    }
    
    func encryption(name: String, deviceId: Int32) -> (SignalPreKeyBundle?,[SignalPreKey])
    {
        do
        {
            let aliceAddress = SignalAddress(name: name, deviceId: deviceId)
//            let bobAddress = SignalAddress(name: "bob", deviceId: 54321)
            
            let inMemoryStore = SignalStoreInMemoryStorage()
            
            let signalStorage = SignalStorage(signalStore: inMemoryStore)
            
            guard let context = SignalContext(storage: signalStorage) else { return  (nil,[]) }
            
            guard let keyHelper = SignalKeyHelper(context: context) else { return  (nil,[]) }
            
            guard let identityKeyPaid = keyHelper.generateIdentityKeyPair() else { return  (nil,[]) }
            
            let localRegistrationId = keyHelper.generateRegistrationId()
            
            inMemoryStore.identityKeyPair = identityKeyPaid
            
            inMemoryStore.localRegistrationId = localRegistrationId
            
            let preKeys = keyHelper.generatePreKeys(withStartingPreKeyId: 0, count: 100)
            
            guard let signedPreKey = keyHelper.generateSignedPreKey(withIdentity: identityKeyPaid, signedPreKeyId: 0) else { return (nil,[]) }
            
            guard let preKey1 = preKeys.first else { return (nil,[]) }
            
            inMemoryStore.storePreKey(preKey1.serializedData() ?? Data(), preKeyId: preKey1.preKeyId)
            
            inMemoryStore.storeSignedPreKey(signedPreKey.serializedData() ?? Data(), signedPreKeyId: signedPreKey.preKeyId)
            
            let alicePreKeyBundle = try SignalPreKeyBundle(registrationId: localRegistrationId, deviceId: UInt32(aliceAddress.deviceId), preKeyId: preKey1.preKeyId, preKeyPublic: preKey1.keyPair?.publicKey ?? Data(), signedPreKeyId: signedPreKey.preKeyId, signedPreKeyPublic: signedPreKey.keyPair?.publicKey ?? Data(), signature: signedPreKey.signature, identityKey: identityKeyPaid.publicKey)
            
            return (alicePreKeyBundle, preKeys)
        }
        catch
        {
            print(error)
         
            return (nil, [])
        }
    }
}

// MARK: - Extensions

extension LoginViewController
{
    func publishDeviceIds(elementId: String, deviceIds:[NSNumber])
    {
        let iq = XMPPIQ.omemo_iqPublishDeviceIds(deviceIds, elementId: elementId, xmlNamespace: OMEMOModuleNamespace.conversationsLegacy)

        print("\n\n****************************\n\nPublish Device ID:::\n",iq.xmlString,"\n\n****************************\n\n")
        
        let xmlElement = try! DDXMLElement(xmlString: iq.xmlString)
        
        self.controller?.xmppStream.send(xmlElement)
    }
    
    func fetchDeviceIds(elementId: String)
    {
        let iq = XMPPIQ.omemo_iqFetchDeviceIds(for: self.controller!.userJID, elementId: elementId, xmlNamespace: OMEMOModuleNamespace.conversationsLegacy)
        
        print("\n\n****************************\n\nFetching devices ID's:::\n",iq.xmlString,"\n\n****************************\n\n")
        
        let xmlElement = try! DDXMLElement(xmlString: iq.xmlString)
        
        self.controller?.xmppStream.send(xmlElement)
    }
    
    func fetchBundle(elementId:String, deviceId: NSNumber, jid: XMPPJID)
    {
        let deviceUint = UInt32(deviceId.intValue)
                
        let iq = XMPPIQ.omemo_iqFetchBundle(forDeviceId: deviceUint, jid: jid, elementId: elementId, xmlNamespace: .conversationsLegacy)
     
        let xmlElement = try! DDXMLElement(xmlString: iq.xmlString)
        
        print("\n\n****************************\n\nFetching Bundle:::\n",iq.xmlString,"\n\n****************************\n\n")

        self.controller?.xmppStream.send(xmlElement)
    }
    
    func publishBundles(elementId:String, deviceId: NSNumber)
    {
        let deviceUint = UInt32(deviceId.intValue)
        
        let bundle = self.encryption(name: deviceId.stringValue, deviceId: deviceId.int32Value)
        
        guard let myPreKeyBundle = bundle.0 else { return }
        
        let preKeys = bundle.1
        
        let omemoSignedPreKey = OMEMOSignedPreKey(preKeyId: myPreKeyBundle.preKeyId, publicKey: myPreKeyBundle.preKeyPublic, signature: myPreKeyBundle.signature)
        
        let omemoPreKeys = preKeys.map { (prekey) -> OMEMOPreKey? in
            
            if let publicKey = prekey.keyPair?.publicKey
            {
                return OMEMOPreKey(preKeyId: prekey.preKeyId, publicKey: publicKey)
            }
            
            return nil
        }.compactMap { $0 }
        
        let omemoBundles = OMEMOBundle(deviceId: deviceUint, identityKey: myPreKeyBundle.identityKey, signedPreKey: omemoSignedPreKey, preKeys: omemoPreKeys)
        
        let iq = XMPPIQ.omemo_iqPublishBundle(omemoBundles, elementId: "publishBundles", xmlNamespace: .conversationsLegacy)
        
        let xmlElement = try! DDXMLElement(xmlString: iq.xmlString)
        
        print("\n\n****************************\n\n Publish Bundles :::\n",iq.xmlString,"\n\n****************************\n\n")

        self.controller?.xmppStream.send(xmlElement)
    }
}



extension LoginViewController: XMPPStreamDelegate
{
    func xmppStreamDidConnect(_ stream: XMPPStream)
    {
        print("Stream: Connected")
        try! stream.authenticate(withPassword: self.controller?.password ?? "")
    }

    func xmppStreamDidAuthenticate(_ sender: XMPPStream)
    {
        self.controller?.xmppStream.send(XMPPPresence())
        print("Stream: Authenticated")
        
        self.fetchDeviceIds(elementId: "fetchDeviceIds")
    }
    
    func xmppStreamWillConnect(_ sender: XMPPStream)
    {
        print("Will connect")
    }

    func xmppStream(_ sender: XMPPStream, socketDidConnect socket: GCDAsyncSocket)
    {
        print("socket")
    }
    
    func xmppStreamDidStartNegotiation(_ sender: XMPPStream)
    {
        print("negotiate")
    }
    
    func xmppStream(_ sender: XMPPStream, didReceiveError error: DDXMLElement)
    {
        print(error);
    }
    
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?)
    {
        print("disconnected");
        
        self.controller?.connect()
    }

    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement)
    {
        print("Stream: Fail to Authenticate");
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool
    {
        if iq.isErrorIQ {
            return false
        }
        else
        {
            print(iq.xmlString)
            
            if let ping = iq.element(forName: "ping")
            {
                print(ping)
                
                let pongiq = XMPPIQ.init(iqType: XMPPIQ.IQType.result, to: XMPPJID(string: iq.fromStr ?? ""), elementID: iq.attribute(forName: "id")?.stringValue)
                
                let xmlElement = try! DDXMLElement(xmlString: pongiq.xmlString)
                
                print(xmlElement)
                
                self.controller?.xmppStream.send(xmlElement)

            }
            
            switch iq.elementID
            {
                case "fetchDeviceIds":
                    
                    print("\n\n****************************\n\nResponse for Fetching Device ID's:::\n",iq.xmlString,"\n\n****************************\n\n")
                    
                    self.validateFetchDeviceId(iq: iq)
                case "publishDeviceId":
                    
                    print("\n\n****************************\n\nResponse for Publishing Device ID's:::\n",iq.xmlString,"\n\n****************************\n\n")
                    
                    self.fetchDeviceIds(elementId: "fetchDeviceIds")
                case "fetchBundles":
                    
                    print("\n\n****************************\n\nResponse for Fetching Bundles:::\n",iq.xmlString,"\n\n****************************\n\n")
                    
                    self.validateFetchedBundle(iq: iq)
                    
                case "publishBundles":
                    
                    print("\n\n****************************\n\nResponse for Publishing Bundles:::\n",iq.xmlString,"\n\n****************************\n\n")
                    
//                    guard let userJID = self.controller?.userJID else { return true }


//                    self.fetchBundle(elementId: "fetchBundles", deviceId: currentDevice, jid: userJID)

            default:
                return true
            }
            
            return true
        }
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage)
    {
        print(message.body ?? "no response")
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence)
    {
        print(presence.name)
    }
    
    func validateFetchDeviceId(iq: XMPPIQ)
    {
        let generateRandomNum = Int.random(in: 1000000..<Int(UINT32_MAX))

        let value = iq.element(forName: "pubsub")
        
        if let devices = value?.element(forName: "items")?.element(forName: "item")?.element(forName: "list")?.elements(forName: "device")
        {
            var val = devices.map {($0.attributes?.first?.stringValue)}.compactMap{$0}.compactMap{NSNumber(value: Int($0) ?? 0)}

            if let currentDevice = currentDeviceId
            {
                if val.contains(currentDevice)
                {
                    print("do nothing and fetch the bundle")
                 
                    guard let userJID = self.controller?.userJID else { return }

                    self.fetchBundle(elementId: "fetchBundles", deviceId: currentDevice, jid: userJID)
                }
                else
                {
                    val.append(currentDevice)
                    
                    self.publishDeviceIds(elementId: "publishDeviceId", deviceIds: val)
                }
            }
            else
            {
                let deviceId = NSNumber(value: generateRandomNum)
                
                currentDeviceId = deviceId
                    
                val.append(deviceId)
                    
                self.publishDeviceIds(elementId: "publishDeviceId", deviceIds: val)
            }
        }
    }
    
    func validateFetchedBundle(iq: XMPPIQ)
    {
        let value = iq.element(forName: "pubsub")

        print("Iq: \n\(iq) \n \n Value: \(value ?? DDXMLElement(name: ""))")
        
        let bundle = iq.omemo_bundle(OMEMOModuleNamespace.conversationsLegacy)
        
        print(bundle?.deviceId ?? "")
    }
    
    func validatePublishedBundles(iq: XMPPIQ)
    {
        let value = iq.element(forName: "pubsub")

        print("Iq: \n\(iq) \n \n Value: \(value)")
    }
    
    
}

//NSXMLElement *queryElement = [iq elementForName:kQuery xmlns:kJabberAdminActivities];


//        let xmls = """
//            <iq xmlns="jabber:client" lang="en" to="919894562544@fly-qa19.mirrorfly.com/14510467502758400889179442" from="919894562544@fly-qa19.mirrorfly.com" type="result" id="fetchDeviceIds"><pubsub xmlns="http://jabber.org/protocol/pubsub"><items node="eu.siacs.conversations.axolotl.devicelist"><item id="65020262735CF"><list xmlns="eu.siacs.conversations.axolotl"><device id ="12345">54677</device><device id ="54677">54677</device></list></item></items></pubsub></iq>
//            """
//
//        do {
//            let obj = try XMLDecoder().decode(FetchIQ.self, from: Data(xmls.utf8))
//
//            print(obj)
//
//            if let devicee = obj.iq?.deviceIdItem?.deviceId
//            {
//                print(devicee.id)
//            }
//
//        }
//        catch
//        {
//            print(error)
//        }


/*
 // Encrypt the messages
 
//            let bobSessionBuilder = SignalSessionBuilder(address: aliceAddress, context: bobContext)
//
//            try bobSessionBuilder.processPreKeyBundle(alicePreKeyBundle)
//
//            let bobSessionCipher = SignalSessionCipher(address: aliceAddress, context: bobContext)
//
//            guard let message = "Hi Bob".data(using: String.Encoding.utf8) else
//            {
//                print("Message data failed")
//                return
//            }
//
//            let bobEncrypted = try bobSessionCipher.encryptData(message)
//
//            let aliceSessionCipher = SignalSessionCipher(address: bobAddress, context: context)
//
//            let bobDecrypted = try aliceSessionCipher.decryptCiphertext(bobEncrypted)
//
//            let messages = String(data: bobDecrypted, encoding: .utf8)
 
//            print(messages ?? "unable to decrypt")
 
 */
