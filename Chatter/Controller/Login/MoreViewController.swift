//
//  MoreViewController.swift
//  Chatter
//
//  Created by Satish Babariya on 10/21/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import UIKit
import Material
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import Firebase

class MoreViewController: UIViewController {
    
    
    // MARK: - Attributes -
    
    var btnPhone : Button!
    var btnEmail : Button!
    var btnFacebook : Button!
    var btnGoogle : Button!
    var btnTwitter : Button!
    var btnCreateAC : Button!
    
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
        self.edgesForExtendedLayout = .all
        self.view.backgroundColor = ViewLayout.Color.primary
        UINavigationBar.appearance().barTintColor = ViewLayout.Color.primary
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()

        self.title = "More Login Options"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Icon.close, style: .done, target: self, action: #selector(dismis))

        
        btnPhone = Button(title: "Phone", titleColor: UIColor.white)
        btnPhone.translatesAutoresizingMaskIntoConstraints = false
        btnPhone.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnPhone.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnPhone)
        btnPhone.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnEmail = Button(title: "Email", titleColor: UIColor.white)
        btnEmail.translatesAutoresizingMaskIntoConstraints = false
        btnEmail.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnEmail.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnEmail)
        btnEmail.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnFacebook = Button(title: "Facebook", titleColor: UIColor.white)
        btnFacebook.translatesAutoresizingMaskIntoConstraints = false
        btnFacebook.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnFacebook.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnFacebook)
        btnFacebook.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnGoogle = Button(title: "Google", titleColor: UIColor.white)
        btnGoogle.translatesAutoresizingMaskIntoConstraints = false
        btnGoogle.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnGoogle.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnGoogle)
        btnGoogle.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnTwitter = Button(title: "Twitter", titleColor: UIColor.white)
        btnTwitter.translatesAutoresizingMaskIntoConstraints = false
        btnTwitter.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnTwitter.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnTwitter)
        btnTwitter.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnCreateAC = Button(title: "Create an account", titleColor: #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1))
        btnCreateAC.translatesAutoresizingMaskIntoConstraints = false
        btnCreateAC.borderColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnCreateAC.borderWidthPreset = .border1
        btnCreateAC.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnCreateAC)
        btnCreateAC.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)

    }
    
    func setViewlayout() {
        let views : [String : Any] = ["btnPhone":btnPhone,"btnEmail":btnEmail,"btnFacebook":btnFacebook,"btnGoogle":btnGoogle,"btnTwitter":btnTwitter,"btnCreateAC":btnCreateAC]
        let metrics : Dictionary = ["btnHeight":ButtonLayout.Raised.height]
        let horizontalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[btnPhone]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraint)
        let verticalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50@249-[btnPhone(==btnHeight)]-[btnEmail(==btnHeight)]-[btnFacebook(==btnHeight)]-[btnGoogle(==btnHeight)]-[btnTwitter(==btnHeight)]-[btnCreateAC(==btnHeight)]-50-|", options: [.alignAllLeft,.alignAllRight], metrics: metrics, views: views)
        self.view.addConstraints(verticalConstraint)
    }
    
    // MARK: - Public interface
    // MARK: - User Interaction
    // MARK: - Internal Helpers
    
    @objc fileprivate func btnAction(_ button: Button) {
        switch button {
        case btnEmail:
            let navController : UINavigationController = UINavigationController(rootViewController: EmailViewController())
            self.present(navController, animated: true, completion: nil)
            break
        case btnPhone:
            let navController : UINavigationController = UINavigationController(rootViewController: PhoneViewController())
            self.present(navController, animated: true, completion: nil)
            break
            
        case btnCreateAC:
            let emailVC : EmailViewController = EmailViewController()
            emailVC.viewType = .signup
            let navController : UINavigationController = UINavigationController(rootViewController: emailVC)
            self.present(navController, animated: true, completion: nil)
            break
        
        default:
            break
        }
    }
    
    @objc func dismis() {
        self.dismiss(animated: true, completion: nil)
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


extension MoreViewController : GIDSignInUIDelegate{
    
    
    @objc fileprivate func btnGoogleLoginAction(_ button: Button) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc fileprivate func btnFacebookLoginAction(_ button: Button) {
        
    }
    
    @objc fileprivate func btnTwitterLoginAction(_ button: Button) {
        
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            Utility.getAppDelegate().loadHomeController()
        }
    }
}
