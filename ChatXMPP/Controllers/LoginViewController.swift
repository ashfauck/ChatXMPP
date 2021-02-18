//
//  LoginViewController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import UIKit

class LoginViewController: UIViewController {

    
    // MARK: - Properties
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        XMPPController.shared.updateStream()

        self.updateXMPP()
    }
    
    // MARK: - Set up
    
    func updateXMPP()
    {
        
        XMPPController.shared.didUpdateLoading = { (success) in

            DispatchQueue.main.async {
                if success
                {
                    self.view.showLoadingHUD()
                }
                else
                {
                    self.view.hideLoadingHUD()
                    
                }
            }
        }
        
        XMPPController.shared.loginSuccess = { () in
            
            DispatchQueue.main.async
            {
                if let vc = self.storyboard?.instantiateViewController(identifier: "WeatherViewController") as? WeatherViewController
                {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
        
        XMPPController.shared.connectStream(jid: jid, password: password)
                
    }
    
}

// MARK: - Extensions

