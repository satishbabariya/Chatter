//
//  ProfileViewController.swift
//  Chatter
//
//  Created by Satish on 04/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import Closures
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import ImagePicker
import Material
import PKHUD
import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    
    fileprivate var btnUpdateImage: RaisedButton!
    fileprivate var btnLogout: RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = .bottom
        
        title = "Profile"
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        btnUpdateImage = RaisedButton()
        btnUpdateImage.setTitle("Change Profile Image", for: .normal)
        btnUpdateImage.titleColor = UIColor.white
        btnUpdateImage.translatesAutoresizingMaskIntoConstraints = false
        btnUpdateImage.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnUpdateImage.cornerRadiusPreset = .cornerRadius1
        btnUpdateImage.setBackgroundColor(color: UIColor.lightGray, forState: .disabled)
        btnUpdateImage.setBackgroundColor(color: #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1), forState: .normal)
        view.addSubview(btnUpdateImage)
        
        btnLogout = RaisedButton()
        btnLogout.setTitle("Logout", for: .normal)
        btnLogout.titleColor = UIColor.white
        btnLogout.translatesAutoresizingMaskIntoConstraints = false
        btnLogout.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnLogout.cornerRadiusPreset = .cornerRadius1
        btnLogout.setBackgroundColor(color: UIColor.lightGray, forState: .disabled)
        btnLogout.setBackgroundColor(color: #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1), forState: .normal)
        view.addSubview(btnLogout)
        
        let views: [String: Any] = ["btnLogout": btnLogout, "btnUpdateImage": btnUpdateImage]
        let metrics: Dictionary = ["btnHeight": ButtonLayout.Raised.height]
        
        let horizontalConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnLogout]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        view.addConstraints(horizontalConstraint)
        let verticalConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[btnLogout(==btnHeight)]-20-[btnUpdateImage(==btnHeight)]-50@249-|", options: [.alignAllLeft, .alignAllRight], metrics: metrics, views: views)
        view.addConstraints(verticalConstraint)
        
        btnLogout.onTap { [weak self] in
            if self == nil {
                return
            }
            HUD.show(HUDContentType.progress)
            do {
                try Auth.auth().signOut()
                HUD.flash(.success)
            } catch {
                print(error.localizedDescription)
                HUD.flash(HUDContentType.error)
            }
        }
        
        btnUpdateImage.onTap { [weak self] in
            if self == nil {
                return
            }
            
            var configuration = Configuration()
            configuration.allowVideoSelection = false
            
            let imagePicker = ImagePickerController(configuration: configuration)
            imagePicker.delegate = self
            imagePicker.imageLimit = 1
            self!.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

extension ProfileViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print(images)
        imagePicker.dismiss(animated: true)
        
        guard let img: UIImage = images.first else { return }
        guard let data: Data = UIImageJPEGRepresentation(img, 0.5) else { return }
        HUD.show(HUDContentType.progress)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        Storage.storage().reference().child(UUID().uuidString + ".jpg").putData(data, metadata: metadata, completion: { [weak self] metadata, error in
            if self == nil { return }
            if let error = error {
                print(error)
                HUD.flash(HUDContentType.error)
            } else if let name = metadata?.name { // if let url: URL = metadata?.downloadURL() {
                print(metadata as Any)
                Storage.storage().reference().child(name).downloadURL(completion: { url, error in
                    if let error = error {
                        print(error)
                        HUD.flash(HUDContentType.error)
                    } else {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.photoURL = url
                        changeRequest?.commitChanges(completion: { error in
                            if let error = error {
                                print(error)
                                HUD.flash(HUDContentType.error)
                            } else {
                                HUD.flash(.success)
                            }
                        })
                    }
                    
                })
            } else {
                HUD.flash(HUDContentType.error)
            }
        })
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true)
    }
    
}
