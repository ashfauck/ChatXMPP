//
//  ChatListViewController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 17/02/21.
//

import UIKit

class ChatListViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setUpTableView()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Set up
    
    func setUpTableView()
    {
        self.tableView.register(identifier: ChatTableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBActions
    
}

// MARK: - Extensions

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0 //XMPPController.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(ofType: ChatTableViewCell.self, for: indexPath)
        
//        cell.updateUI(user: XMPPController.shared.users[indexPath.row])
        
        return cell
    }
    
    
}
