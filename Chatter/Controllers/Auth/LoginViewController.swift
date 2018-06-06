//
//  EmailViewController.swift
//  Chatter
//
//  Created by Satish Babariya on 10/21/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import Closures
import FirebaseAuth
import Material
import PKHUD
import Reachability
import RxCocoa
import RxSwift
import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Attributes -
    
    fileprivate var txtEmail: ErrorTextField!
    fileprivate var txtPassword: TextField!
    fileprivate var btnLogin: RaisedButton!
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViewControls()
        setViewlayout()
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
        
        title = "Login With Email"
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icon.arrowBack, style: .done, target: self, action: #selector(dismis))
        
        txtEmail = ErrorTextField()
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        txtEmail.placeholder = "Email"
        txtEmail.detail = "Error, incorrect email"
        txtEmail.isClearIconButtonEnabled = true
        txtEmail.keyboardType = .emailAddress
        txtEmail.autocorrectionType = .no
        txtEmail.autocapitalizationType = .none
        txtEmail.isPlaceholderUppercasedWhenEditing = true
        //txtEmail.placeholderAnimation = .hidden
        view.addSubview(txtEmail)
        
        txtPassword = TextField()
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        txtPassword.placeholder = "Password"
        txtPassword.detail = "At least 8 characters"
        txtPassword.clearButtonMode = .whileEditing
        txtPassword.isVisibilityIconButtonEnabled = true
        txtPassword.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(txtPassword.isSecureTextEntry ? 0.38 : 0.54)
        view.addSubview(txtPassword)
        
        btnLogin = RaisedButton()
        
        btnLogin.setTitle("Login", for: .normal)
        
        btnLogin.titleColor = UIColor.white
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        btnLogin.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnLogin.cornerRadiusPreset = .cornerRadius1
        view.addSubview(btnLogin)
        btnLogin.setBackgroundColor(color: UIColor.lightGray, forState: .disabled)
        btnLogin.setBackgroundColor(color: #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1), forState: .normal)
        
        btnLogin.onTap { [weak self] in
            if self == nil {
                return
            }
            self!.btnAction()
        }
        
        let emailValidation: Observable<Bool> = txtEmail.rx.text
            .map { text -> Bool in
                let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                return emailTest.evaluate(with: text)
            }
            .share(replay: 1)
        
        let passwordValidation: Observable<Bool> = txtPassword.rx.text
            .map { text -> Bool in
                text!.count >= 8
            }
            .share(replay: 1)
        
        let everythingValid: Observable<Bool>
            = Observable.combineLatest(emailValidation, passwordValidation) { $0 && $1 }
        
        everythingValid.bind(to: btnLogin.rx.isEnabled).disposed(by: disposeBag)
        
    }
    
    func setViewlayout() {
        let views: [String: Any] = ["txtEmail": txtEmail, "txtPassword": txtPassword, "btnLogin": btnLogin]
        let metrics: Dictionary = ["btnHeight": ButtonLayout.Raised.height]
        let horizontalConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[txtEmail]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        view.addConstraints(horizontalConstraint)
        let verticalConstraint: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[txtEmail]-30-[txtPassword]-50-[btnLogin(==btnHeight)]-50@249-|", options: [.alignAllLeft, .alignAllRight], metrics: metrics, views: views)
        view.addConstraints(verticalConstraint)
    }
    
    fileprivate func btnAction() {
        view.endEditing(true)
        HUD.show(HUDContentType.progress)
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!, completion: { _, error in
            if let error = error {
                print("ERROR : Auth.auth().signIn -> ", error.localizedDescription)
                HUD.flash(.error)
            } else {
                HUD.flash(.success)
            }
        })
        
    }
    
    @objc func dismis() {
        dismiss(animated: true, completion: nil)
    }
    
}
