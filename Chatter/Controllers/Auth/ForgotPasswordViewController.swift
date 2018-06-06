//
//  ForgotPasswordViewController
//  Chatter
//
//  Created by Satish Babariya on 10/21/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa

class ForgotPasswordViewController: UIViewController {
    
    
    // MARK: - Attributes -
    
    var txtEmail : ErrorTextField!
    var btnResetPassword : RaisedButton!
    let disposeBag : DisposeBag = DisposeBag()
    
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
        
        self.title = "Forgot password?"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icon.arrowBack, style: .done, target: self, action: #selector(dismis))
        
        txtEmail = ErrorTextField()
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        txtEmail.placeholder = "Email"
        txtEmail.detail = "Error, incorrect email"
        txtEmail.isClearIconButtonEnabled = true
        txtEmail.delegate = self
        txtEmail.isPlaceholderUppercasedWhenEditing = true
        //txtEmail.placeholderAnimation = .hidden
        view.addSubview(txtEmail)
      
        
        btnResetPassword = RaisedButton(title: "Reset Password", titleColor: UIColor.white)
        btnResetPassword.translatesAutoresizingMaskIntoConstraints = false
        btnResetPassword.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnResetPassword.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnResetPassword)
        btnResetPassword.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        btnResetPassword.setBackgroundColor(color: UIColor.lightGray, forState: .disabled)
        btnResetPassword.setBackgroundColor(color:  #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1), forState: .normal)
        
        let emailValidation: Observable<Bool> = txtEmail.rx.text
            .map{ text -> Bool in
                let emailTest = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
                return emailTest.evaluate(with: text)
            }
            .share(replay: 1)
        emailValidation.bind(to: btnResetPassword.rx.isEnabled).disposed(by: disposeBag)
        
    }
    
    func setViewlayout() {
        let views : [String : Any] = ["txtEmail":txtEmail,"btnResetPassword":btnResetPassword]
        let metrics : Dictionary = ["btnHeight":ButtonLayout.Raised.height]
        let horizontalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[txtEmail]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraint)
        let verticalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[txtEmail]-30-[btnResetPassword(==btnHeight)]-50@249-|", options: [.alignAllLeft,.alignAllRight], metrics: metrics, views: views)
        self.view.addConstraints(verticalConstraint)
    }
    
    // MARK: - Public interface
    // MARK: - User Interaction
    // MARK: - Internal Helpers
    
    @objc fileprivate func btnAction(_ button: Button) {
        print("Action")
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

extension ForgotPasswordViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    func textField(textField: TextField, didChange text: String?) {
        if (text?.isEmpty)! {
            txtEmail.isErrorRevealed = false
        } else {
            if Utility.isValidEmail(string: text!){
                txtEmail.isErrorRevealed = false
            } else {
                txtEmail.isErrorRevealed = true
            }
        }
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.isErrorRevealed = true
        return true
    }
}


