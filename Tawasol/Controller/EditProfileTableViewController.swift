//
//  EditProfileTableViewController.swift
//  Tawasol
//
//  Created by Hatem on 27/04/2023.
//

import UIKit
import Gallery
import ProgressHUD

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView =  UIView()
        showUserInfo()
        configureTextField()
        
    }
    var gallery : GalleryController!
    
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
        showImageGallery()
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
    // MARK: - Gallery
    
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab , .cameraTab ]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallery, animated: true)
    }
    private func uploadAvatarImage(_ image : UIImage) {
        let fileDirectory = "Avatars/" + "\(User.currentId)" + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { avatarLink in
            if var user = User.currentUser {
                user.avatarLink = avatarLink ?? ""
                saveUserLocally(user)
                FUserListner.shared.saveUserToFirestore(user)
            }
            
            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 0.5)! as NSData , fileName: User.currentId )
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

extension EditProfileTableViewController : GalleryControllerDelegate {
    
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        if images.count > 0 {
            images.first!.resolve { avatarImage in
                if avatarImage != nil {
                    self.uploadAvatarImage(avatarImage!)
                    self.avatarImageViewOutlet.image = avatarImage
                } else {
                    ProgressHUD.showError("Could not select image")
                }
            }
        }
        controller.dismiss(animated: true)

    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true)

    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true)

    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true)
    }
    
    
}
