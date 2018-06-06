//
//  MoreViewController.swift
//  Chatter
//
//  Created by Satish Babariya on 10/21/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import Firebase
import Material
import PKHUD
import UIKit

class MoreViewController: UIViewController {
    
    // MARK: - Attributes -
    
    var btnPhone: Button!
    var btnEmail: Button!
    var btnFacebook: Button!
    var btnGoogle: Button!
    var btnTwitter: Button!
    var btnCreateAC: Button!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewControls()
        setViewlayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Layout
    
    func loadViewControls() {
        edgesForExtendedLayout = .all
        view.backgroundColor = ViewLayout.Color.primary
        UINavigationBar.appearance().barTintColor = ViewLayout.Color.primary
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        
        title = "More Login Options"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icon.close, style: .done, target: self, action: #selector(dismis))
        
        btnPhone = Button(title: "Phone", titleColor: UIColor.white)
        btnPhone.translatesAutoresizingMaskIntoConstraints = false
        btnPhone.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnPhone.cornerRadiusPreset = .cornerRadius1
        view.addSubview(btnPhone)
        btnPhone.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnEmail = Button(title: "Email", titleColor: UIColor.white)
        btnEmail.translatesAutoresizingMaskIntoConstraints = false
        btnEmail.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnEmail.cornerRadiusPreset = .cornerRadius1
        view.addSubview(btnEmail)
        btnEmail.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnFacebook = Button(title: "Facebook", titleColor: UIColor.white)
        btnFacebook.translatesAutoresizingMaskIntoConstraints = false
        btnFacebook.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnFacebook.cornerRadiusPreset = .cornerRadius1
        view.addSubview(btnFacebook)
        
        btnGoogle = Button(title: "Google", titleColor: UIColor.white)
        btnGoogle.translatesAutoresizingMaskIntoConstraints = false
        btnGoogle.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnGoogle.cornerRadiusPreset = .cornerRadius1
        view.addSubview(btnGoogle)
        
        btnTwitter = Button(title: "Twitter", titleColor: UIColor.white)
        btnTwitter.translatesAutoresizingMaskIntoConstraints = false
        btnTwitter.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnTwitter.cornerRadiusPreset = .cornerRadius1
        view.addSubview(btnTwitter)
        
        btnCreateAC = Button(title: "Create an account", titleColor: #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1))
        btnCreateAC.translatesAutoresizingMaskIntoConstraints = false
        btnCreateAC.borderColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnCreateAC.borderWidthPreset = .border1
        btnCreateAC.cornerRadiusPreset = .cornerRadius1
        view.addSubview(btnCreateAC)
        btnCreateAC.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func setViewlayout() {
        let views: [String: Any] = ["btnPhone": btnPhone, "btnEmail": btnEmail, "btnFacebook": btnFacebook, "btnGoogle": btnGoogle, "btnTwitter": btnTwitter, "btnCreateAC": btnCreateAC]
        let metrics: Dictionary = ["btnHeight": ButtonLayout.Raised.height]
        let horizontalConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[btnPhone]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        view.addConstraints(horizontalConstraint)
        let verticalConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50@249-[btnPhone(==btnHeight)]-[btnEmail(==btnHeight)]-[btnFacebook(==btnHeight)]-[btnGoogle(==btnHeight)]-[btnTwitter(==btnHeight)]-[btnCreateAC(==btnHeight)]-50-|", options: [.alignAllLeft, .alignAllRight], metrics: metrics, views: views)
        view.addConstraints(verticalConstraint)
    }
    
    // MARK: - Public interface
    // MARK: - User Interaction
    // MARK: - Internal Helpers
    
    @objc fileprivate func btnAction(_ button: Button) {
        switch button {
        case btnEmail:
            let navController: UINavigationController = UINavigationController(rootViewController: EmailViewController())
            present(navController, animated: true, completion: nil)
            break
        case btnPhone:
            let navController: UINavigationController = UINavigationController(rootViewController: PhoneViewController())
            present(navController, animated: true, completion: nil)
            break
            
        case btnCreateAC:
            let emailVC: EmailViewController = EmailViewController()
            emailVC.viewType = .signup
            let navController: UINavigationController = UINavigationController(rootViewController: emailVC)
            present(navController, animated: true, completion: nil)
            break
            
        default:
            break
        }
    }
    
    @objc func dismis() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Server Request
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

//extension MoreViewController: GIDSignInUIDelegate {
//
//    @objc fileprivate func btnGoogleLoginAction(_ button: Button) {
//        if Utility.getAppDelegate().reachability.connection == Reachability.Connection.none {
//            displayBottomMessage(message: "Network not reachable", type: .warning)
//        } else {
//            DispatchQueue.main.async(execute: { () -> Void in
//                HUD.show(.progress)
//            })
//            GIDSignIn.sharedInstance().uiDelegate = self
//            GIDSignIn.sharedInstance().signIn()
//        }
//    }
//
//    @objc fileprivate func btnFacebookLoginAction(_ button: Button) {
//        if Utility.getAppDelegate().reachability.connection == Reachability.Connection.none {
//            displayBottomMessage(message: "Network not reachable", type: .warning)
//        } else {
//            DispatchQueue.main.async(execute: { () -> Void in
//                HUD.show(.progress)
//            })
//            let loginManager = FBSDKLoginManager()
//            loginManager.logIn(withReadPermissions: ["email"], from: self, handler: { [weak self] result, error in
//                if self == nil {
//                    return
//                }
//                if let error = error {
//                    HUD.flash(.error)
//                    self?.displayBottomMessage(message: (error.localizedDescription), type: .error)
//                } else if result!.isCancelled {
//                    HUD.flash(.error)
//                    self?.displayBottomMessage(message: "User canceled", type: .error)
//                } else {
//
//                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//                    self?.firebaseLogin(credential)
//                }
//            })
//        }
//    }
//
//    @objc fileprivate func btnTwitterLoginAction(_ button: Button) {
//        if Utility.getAppDelegate().reachability.connection == Reachability.Connection.none {
//            displayBottomMessage(message: "Network not reachable", type: .warning)
//        } else {
//            DispatchQueue.main.async(execute: { () -> Void in
//                HUD.show(.progress)
//            })
//            Twitter.sharedInstance().logIn { [weak self] session, error in
//                if self == nil {
//                    return
//                }
//                if let session = session {
//                    let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
//                    print(session.userID)
//                    print(session.userName)
//                    self?.firebaseLogin(credential)
//                } else {
//                    HUD.flash(.error)
//                    self?.displayBottomMessage(message: (error?.localizedDescription)!, type: .error)
//                }
//            }
//        }
//    }
//
//    func firebaseLogin(_ credential: AuthCredential) {
//        Auth.auth().signIn(with: credential) { [weak self] _, error in
//            if self == nil {
//                return
//            }
//            if error == nil {
//                HUD.flash(.success)
//                Utility.getAppDelegate().loadRegisterController()
//            } else {
//                HUD.flash(.error)
//                if let newError: NSError = error as NSError? {
//                    if let code: FirebaseAuthErrorCodes = FirebaseAuthErrorCodes(rawValue: newError.code) {
//                        self?.displayBottomMessage(message: FirebaseAuthError.shared.translate(FirebaseErrorCode: code), type: .error)
//                    } else {
//                        self?.displayBottomMessage(message: "Unknown Error", type: .error)
//                    }
//                }
//            }
//        }
//    }
//
//    //    func twitterRequestForEmail() {
//    //        let client = TWTRAPIClient.withCurrentUser()
//    //        client.requestEmail { email, error in
//    //            if (email != nil) {
//    //                self.updateEmail(email: email!)
//    //            } else {
//    //                print("error: \(error?.localizedDescription)");
//    //            }
//    //        }
//    //    }
//    //
//    //    func updateEmail(email: String){
//    //        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
//    //            HUD.flash(.success)
//    //            Utility.getAppDelegate().loadHomeController()
//    //        }
//    //    }
//}

