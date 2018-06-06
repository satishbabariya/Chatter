//
//  PhoneViewController.swift
//  Chatter
//
//  Created by Satish Babariya on 10/21/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import UIKit
import Material
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
    
    
    // MARK: - Attributes -
    
    var txtPhone : ErrorTextField!
    var btnNext : RaisedButton!
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
        
        self.title = "Enter your Phone"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Icon.arrowBack, style: .done, target: self, action: #selector(dismis))
        
        txtPhone = ErrorTextField()
        txtPhone.translatesAutoresizingMaskIntoConstraints = false
        txtPhone.placeholder = "Phone"
        txtPhone.detail = "Error, incorrect Number"
        txtPhone.isClearIconButtonEnabled = true
        txtPhone.keyboardType = .phonePad
        txtPhone.delegate = self
        txtPhone.isPlaceholderUppercasedWhenEditing = true
        //txtPhone.placeholderAnimation = .hidden
        view.addSubview(txtPhone)
        
        
        btnNext = RaisedButton(title: "Next", titleColor: UIColor.white)
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        btnNext.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1)
        btnNext.cornerRadiusPreset = .cornerRadius1
        self.view.addSubview(btnNext)
        btnNext.addTarget(self, action: #selector(btnAction(_:)), for: UIControlEvents.touchUpInside)
        btnNext.setBackgroundColor(color: UIColor.lightGray, forState: .disabled)
        btnNext.setBackgroundColor(color:  #colorLiteral(red: 0.2941176471, green: 0.4549019608, blue: 1, alpha: 1), forState: .normal)
        
        let emailValidation: Observable<Bool> = txtPhone.rx.text
            .map{ text -> Bool in
                let emailTest = NSPredicate(format:"SELF MATCHES %@", "^((\\+)|(00))[0-9]{6,14}$")
                return emailTest.evaluate(with: text)
            }
            .share(replay: 1)
        emailValidation.bind(to: btnNext.rx.isEnabled).disposed(by: disposeBag)
        
    }
    
    func setViewlayout() {
        let views : [String : Any] = ["txtPhone":txtPhone,"btnNext":btnNext]
        let metrics : Dictionary = ["btnHeight":ButtonLayout.Raised.height]
        let horizontalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[txtPhone]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraint)
        let verticalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[txtPhone]-30-[btnNext(==btnHeight)]-50@249-|", options: [.alignAllLeft,.alignAllRight], metrics: metrics, views: views)
        self.view.addConstraints(verticalConstraint)
    }
    
    // MARK: - Public interface
    // MARK: - User Interaction
    // MARK: - Internal Helpers
    
    @objc fileprivate func btnAction(_ button: Button) {
       
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

extension PhoneViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? ErrorTextField)?.isErrorRevealed = false
    }
    
    func textField(textField: TextField, didChange text: String?) {
        if (text?.isEmpty)! {
            txtPhone.isErrorRevealed = false
        } else {
            if Utility.isValidPhone(string: text!){
                txtPhone.isErrorRevealed = false
            } else {
                txtPhone.isErrorRevealed = true
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



