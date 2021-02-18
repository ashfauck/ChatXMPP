//
//  ViewController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 16/02/21.
//

import UIKit
import XMPPFramework
import HeadStart

public enum OnlineType:String, Codable
{
    case available = "available"
    case unavailable = "unavailable"
    case none = ""
}



class HomeViewController: UIViewController {

    
    // MARK: - Properties
    let xmpp = XMPPController()
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        if let viewCon = self.containerView.subviews.first?.parentViewController, let pageVC = viewCon as? PageViewController
//        {
//            pageVC.setViewControllers([pageVC.viewController(at: sender.selectedSegmentIndex)], direction: .forward, animated: true, completion: nil)
//        }

//        self.view.addTapGesture(tapNumber: 1, target: self, action: #selector(didTapView))
    }
    
    // MARK: - Set up
    
    @objc func didTapView()
    {
        print(xmpp.users)
    }
    
    // MARK: - IBActions
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl)
    {
        
        if let viewCon = self.containerView.subviews.first?.parentViewController, let pageVC = viewCon as? PageViewController
        {
            pageVC.setViewControllers([pageVC.viewController(at: sender.selectedSegmentIndex)], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - Extensions

