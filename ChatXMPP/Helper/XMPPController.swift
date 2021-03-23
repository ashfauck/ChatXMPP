//
//  XMPPController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 17/02/21.
//

import UIKit
import XMPPFramework

//class XMPPController: NSObject
//{
//    static let shared = XMPPController()
//
//    var stream = XMPPStream()
//    var users:[Users] = []
//
//    var didUpdateLoading:((_ success:Bool)->())?
//    var loginSuccess:(()->())?
//    var alertMessage:((_ message:String)->())?
//
//
//    var password:String? = nil
//    var JID:String? = nil
//
//
////    let onlineUsers:
//
//    override init()
//    {
//        super.init()
//
//        self.updateStream()
//    }
//
//    func updateStream()
//    {
//        stream = XMPPStream()
//
//        stream.hostName = "fly-qa19.mirrorfly.com"
//        stream.hostPort = 5222
//        stream.startTLSPolicy = .preferred
//        stream.myJID = XMPPJID(string: "919894562544@fly-qa19.mirrorfly.com/Mobile-1602F24AF37F4293832E54AAF83A33EF")
//        stream.addDelegate(self, delegateQueue: .main)
//    }
//
//    func connectStream(jid:String, password: String)
//    {
//        stream.disconnect()
//
//        guard let userJID = XMPPJID(string: jid) else
//        {
//            print("Wrong JID")
//            self.alertMessage?("JID is invalid")
//            return
//        }
//
//        self.password = password
//
//        stream.myJID = userJID
//
//        do
//        {
//            try self.stream.connect(withTimeout: -1)
//        }
//        catch
//        {
//            print("Auth error:::\(error)")
//        }
//    }
//
//    func fetch()
//    {
//
//    }
//
//}

enum XMPPControllerError: Error {
    case wrongUserJID
}

class XMPPController: NSObject {
    var xmppStream: XMPPStream

    let hostName: String
    let userJID: XMPPJID
    let hostPort: UInt16
    let password: String

    init(hostName: String, userJIDString: String, hostPort: UInt16 = 5222, password: String) throws {
        guard let userJID = XMPPJID(string: userJIDString) else {
            throw XMPPControllerError.wrongUserJID
        }

        self.hostName = hostName
        self.userJID = userJID
        self.hostPort = hostPort
        self.password = password

        // Stream Configuration
        self.xmppStream = XMPPStream()
        self.xmppStream.hostName = hostName
        self.xmppStream.hostPort = hostPort
        self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
        self.xmppStream.myJID = userJID
        self.xmppStream.keepAliveInterval = 300
        super.init()

    }
    
    func connect() {
        
//        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)

        if !self.xmppStream.isDisconnected
        {
            return
        }

       try! self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
    }
}


//extension XMPPController: XMPPStreamDelegate
//{
//    func xmppStream(_ sender: XMPPStream, socketDidConnect socket: GCDAsyncSocket)
//    {
//        print("did connect",sender.isConnected)
//    }
//
//    func xmppStreamWillConnect(_ sender: XMPPStream)
//    {
//        print("Will connect")
//    }
//
//    func xmppStreamDidConnect(_ sender: XMPPStream)
//    {
//        print("Did connect")
//
//        do {
//
////            guard let pass = password, pass.count > 0 else
////            {
////                self.alertMessage?("Password cannot be blank")
////                print("Password cannot be blank")
////                return
////            }
//
////            self.didUpdateLoading?(true)
//
////            try self.stream.authenticate(withPassword: pass)
//        }
//        catch
//        {
//            print(error)
////            self.alertMessage?(error.localizedDescription)
//        }
//    }
//
//    func xmppStreamDidAuthenticate(_ sender: XMPPStream)
//    {
//        print("Did authenticate")
//
//        self.didUpdateLoading?(false)
//
//        self.loginSuccess?()
//
//        self.stream.send(XMPPPresence())
//
//        print("Stream Authenticated::: \n senderDetails:\(sender.myJID!)")
//    }
//
//    func xmppStream(_ sender: XMPPStream, didNotRegister error: DDXMLElement)
//    {
//        print(error.localName ?? "")
//
//    }
//
//    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement)
//    {
//        self.didUpdateLoading?(false)
//        self.alertMessage?("Failed to authenticate")
//    }
//
//    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence)
//    {
//        guard let isOnline = OnlineType(rawValue: presence.type ?? "") else
//        {
//            return
//        }
//
//        let obj = Users()
//        obj.username = presence.from?.user
//        obj.jid = presence.from?.bare
//        obj.isOnline = isOnline
//
//        if users.contains(obj)
//        {
//            self.users = self.users.map({ (use) -> Users in
//
//                if obj == use
//                {
//                    use.isOnline = isOnline
//                    use.jid = obj.jid
//                }
//
//                return use
//            })
//        }
//        else
//        {
//            self.users.append(obj)
//        }
//    }
//
//
//
//    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage)
//    {
//        print("Messages:: \(message)")
//    }
//
//    func xmppStream(_ sender: XMPPStream, didReceiveCustomElement element: DDXMLElement)
//    {
//        print("Element:: \(element)")
//    }
//}
