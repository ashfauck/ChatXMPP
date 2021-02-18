//
//  ChatTableViewCell.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 17/02/21.
//

import UIKit

class ChatTableViewCell: UITableViewCell
{

    @IBOutlet weak var userNAMELBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(user: Users)
    {
        let online = (user.isOnline ?? .none) == .available
        
        self.userNAMELBL.text = "\(user.username ?? "No name found") \("(\(online ? "Online" : "Offline"))")"
    }
    
    static var cellHeight:CGFloat
    {
        return 44.0
    }
}



extension UITableViewCell
{
    static var identifier: String
    {
        return String(describing: self)
    }
    
    static var nib: UINib
    {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}

