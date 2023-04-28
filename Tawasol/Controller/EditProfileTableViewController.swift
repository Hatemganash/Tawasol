//
//  EditProfileTableViewController.swift
//  Tawasol
//
//  Created by Hatem on 27/04/2023.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView =  UIView()
        showUserInfo()
        configureTextField()
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "colorTableview")
        
        return headerView
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageViewOutlet: UIImageView!
    
    @IBOutlet weak var statusLBLOutlet: UILabel!
    
    @IBOutlet weak var usernameTextFieldOutlet: UITextField!
    
    
    // MARK: - Actions
    
    
    @IBAction func editBtnAction(_ sender: Any) {
    }
    
    private func showUserInfo(){
        if let user = User.currentUser {
            
            usernameTextFieldOutlet.text = user.username
            statusLBLOutlet.text = user.status
            if user.avatarLink != "" {
                // MARK: - Set Avatar Img
            }
        }
        
        
    }
    
    private func configureTextField(){
        usernameTextFieldOutlet.delegate = self
        usernameTextFieldOutlet.clearButtonMode = .whileEditing
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextFieldOutlet {
            if textField.text != "" {
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FUserListner.shared.saveUserToFirestore(user)
                }
            }
            textField.resignFirstResponder()
            return false
        }
        return true
        
    }
    
    
}
