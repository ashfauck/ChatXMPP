//
//  XMPPController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 17/02/21.
//

import UIKit
import XMPPFramework

class XMPPController: NSObject
{
    static let shared = XMPPController()
    
    var stream = XMPPStream()
    var users:[Users] = []
    
    var didUpdateLoading:((_ success:Bool)->())?
    var loginSuccess:(()->())?

    
    var password:String? = nil
    var JID:String? = nil
    
    
//    let onlineUsers:
    
    override init()
    {
        super.init()
    }
    
    func updateStream()
    {
        stream = XMPPStream()
        
        stream.hostName = "stun.joiint.com"
        stream.hostPort = 5222
        
        stream.startTLSPolicy = .allowed
        stream.addDelegate(self, delegateQueue: .main)

    }
    
    func connectStream(jid:String, password: String)
    {
        
        guard let userJID = XMPPJID(string: jid) else
        {
            print("Wrong JID")
            return
        }

        self.password = password
        
        stream.myJID = userJID


        if !self.stream.isDisconnected
        {
            self.loginSuccess?()
            print("Already connected")
            return
        }


        try! self.stream.connect(withTimeout: XMPPStreamTimeoutNone)
    }

    func fetch()
    {
        
    }
    
}


extension XMPPController: XMPPStreamDelegate
{
    func xmppStreamDidConnect(_ sender: XMPPStream)
    {
        do {
            
            guard let pass = password else {
                print("Password cannot be blank")
                return
            }
            
            self.didUpdateLoading?(true)

            try self.stream.authenticate(withPassword: pass)
        }
        catch
        {
            print(error)
        }
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream)
    {
        self.didUpdateLoading?(false)
        
        self.loginSuccess?()

        self.stream.send(XMPPPresence())
        
//        self.showToast(message: "XMPP Authenticated (\(sender.myJID!))", duration: 10.0)
        
        print("Stream Authenticated::: \nsenderDetails:\(sender.myJID!)")
    }
    
    func xmppStream(_ sender: XMPPStream, didNotAuthenticate error: DDXMLElement)
    {
        self.didUpdateLoading?(false)
        print("Failed to Authenticate")
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence)
    {
        guard let isOnline = OnlineType(rawValue: presence.type ?? "") else
        {
            return
        }
        
        let obj = Users()
        obj.username = presence.from?.user
        obj.jid = presence.from?.bare
        obj.isOnline = isOnline
        
        if users.contains(obj)
        {
            self.users = self.users.map({ (use) -> Users in
              
                if obj == use
                {
                    use.isOnline = isOnline
                    use.jid = obj.jid
                }
                
                return use
            })
        }
        else
        {
            self.users.append(obj)
        }
    }
    
    
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage)
    {
        print("Messages:: \(message)")
    }
    
    func xmppStream(_ sender: XMPPStream, didReceiveCustomElement element: DDXMLElement)
    {
        print("Element:: \(element)")
    }
}
