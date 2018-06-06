//
//  SplashViewController.swift
//  Chatter
//
//  Created by Satish Babariya on 10/21/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import UIKit
import Gifu
import TinyConstraints
import Material

class SplashViewController: UIViewController {
    
    
    // MARK: - Attributes -
    
    var firebaseLogo : GIFImageView!
    var btnCreateAcount : Button!
    var btnEmailLogin : Button!
    var btnMore : Button!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewControls()
        setViewlayout()
    }
    
    // MARK: - Layout
    
    func loadViewControls() {
        self.edgesForExtendedLayout = .all
        self.view.backgroundColor = ViewLayout.Color.primary
        
        firebaseLogo = GIFImageView()
        firebaseLogo.translatesAutoresizingMaskIntoConstraints = false
        firebaseLogo.animate(withGIFNamed: "firebaseload")
        firebaseLogo.contentMode = .scaleAspectFit
        self.view.addSubview(firebaseLogo)
        
        btnCreateAcount = Button(title: "Create an account", titleColor: UIColor.white)
        btnCreateAcount.translatesAutoresizingMaskIntoConstraints = false
        btnCreateAcount.backgroundColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        btnCreateAcount.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnCreateAcount)
        btnCreateAcount.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnEmailLogin = Button(title: "Login with Email", titleColor: UIColor.white)
        btnEmailLogin.translatesAutoresizingMaskIntoConstraints = false
        btnEmailLogin.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnEmailLogin.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnEmailLogin)
        btnEmailLogin.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        
        btnMore = Button(title: "More ways to login", titleColor: #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1))
        btnMore.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnMore)
        btnMore.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setViewlayout() {
        let views : [String : Any] = ["firebaseLogo":firebaseLogo,"btnCreateAcount":btnCreateAcount,"btnEmailLogin":btnEmailLogin,"btnMore":btnMore]
        let metrics : Dictionary = ["btnHeight":ButtonLayout.Raised.height]
        let horizontalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[firebaseLogo]-30-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraint)
        let verticalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[firebaseLogo]-[btnCreateAcount(==btnHeight)]-[btnEmailLogin(==btnHeight)]-[btnMore(==btnHeight)]-30-|", options: [.alignAllLeft,.alignAllRight], metrics: metrics, views: views)
        self.view.addConstraints(verticalConstraint)
    }
    
    // MARK: - Internal Helpers
    
    @objc fileprivate func btnAction(_ button: Button) {
        switch button {
        case btnCreateAcount:
            let emailVC : EmailViewController = EmailViewController()
            emailVC.viewType = .signup
            let navController : UINavigationController = UINavigationController(rootViewController: emailVC)
            self.present(navController, animated: true, completion: nil)
            break
        case btnEmailLogin:
            let navController : UINavigationController = UINavigationController(rootViewController: LoginViewController())
            self.present(navController, animated: true, completion: nil)
            break
        case btnMore:
            let navController : UINavigationController = UINavigationController(rootViewController: MoreViewController())
            self.present(navController, animated: true, completion: nil)        
            break
        default:
            break
        }
    }
    
}
