//
//  LoginController.swift
//  Chatter
//
//  Created by Satish Babariya on 10/19/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit
import TransitionButton
import TinyConstraints

class LoginController: UIViewController {
    
    
    // MARK: - Attributes -
    
    fileprivate var btnGoogle : TransitionButton!
    fileprivate var btnFacebook : TransitionButton!
    fileprivate var btnTwitter : TransitionButton!
    fileprivate var btnEmail : TransitionButton!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Login"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
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
        
        btnEmail = TransitionButton()
        btnEmail.translatesAutoresizingMaskIntoConstraints = false
        btnEmail.setTitle("Email", for: .normal)
        btnEmail.backgroundColor = ButtonLayout.Color.email
        btnEmail.cornerRadius = 2.0
        btnEmail.spinnerColor = .white
        self.view.addSubview(btnEmail)
        btnEmail.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        btnTwitter = TransitionButton()
        btnTwitter.translatesAutoresizingMaskIntoConstraints = false
        btnTwitter.setTitle("Twitter", for: .normal)
        btnTwitter.backgroundColor = ButtonLayout.Color.twitter
        btnTwitter.cornerRadius = 2.0
        btnTwitter.spinnerColor = .white
        self.view.addSubview(btnTwitter)
        btnTwitter.addTarget(self, action: #selector(btnTwitterLoginAction(_:)), for: .touchUpInside)
        
        btnFacebook = TransitionButton()
        btnFacebook.translatesAutoresizingMaskIntoConstraints = false
        btnFacebook.setTitle("Facebook", for: .normal)
        btnFacebook.backgroundColor = ButtonLayout.Color.facebook
        btnFacebook.cornerRadius = 2.0
        btnFacebook.spinnerColor = .white
        self.view.addSubview(btnFacebook)
        btnFacebook.addTarget(self, action: #selector(btnFacebookLoginAction(_:)), for: .touchUpInside)
        
        btnGoogle = TransitionButton()
        btnGoogle.translatesAutoresizingMaskIntoConstraints = false
        btnGoogle.setTitle("Google", for: .normal)
        btnGoogle.backgroundColor = ButtonLayout.Color.google
        btnGoogle.cornerRadius = 2.0
        btnGoogle.spinnerColor = .white
        self.view.addSubview(btnGoogle)
        btnGoogle.addTarget(self, action: #selector(btnGoogleLoginAction(_:)), for: .touchUpInside)
        
        
    }
    
    func setViewlayout() {
        
        let views : [String : Any] = ["btnEmail":btnEmail,"btnGoogle":btnGoogle,"btnFacebook":btnFacebook,"btnTwitter":btnTwitter]
        let metrics : Dictionary = ["btnHeight":ButtonLayout.Raised.height]
        
        let horizontalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[btnEmail]-50-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views)
        self.view.addConstraints(horizontalConstraint)
        
        let verticalConstraint : [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50@249-[btnEmail(==btnHeight)]-[btnGoogle(==btnHeight)]-[btnFacebook(==btnHeight)]-[btnTwitter(==btnHeight)]-50-|", options: [.alignAllLeft,.alignAllRight], metrics: metrics, views: views)
        self.view.addConstraints(verticalConstraint)
        
        
    }
    
    // MARK: - Public interface
    
    // MARK: - User Interaction
    
    
    // MARK: - Internal Helpers
    
    @objc fileprivate func buttonAction(_ button: TransitionButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(3) // 3: Do your networking task or background work here.
            
            DispatchQueue.main.async(execute: { () -> Void in
                // 4: Stop the animation, here you have three options for the `animationStyle` property:
                // .expand: useful when the task has been compeletd successfully and you want to expand the button and transit to another view controller in the completion callback
                // .shake: when you want to reflect to the user that the task did not complete successfly
                // .normal
                button.stopAnimation(animationStyle: .expand, completion: {
                    
                })
            })
        })
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

extension LoginController : GIDSignInUIDelegate{
    
    
    @objc fileprivate func btnGoogleLoginAction(_ button: TransitionButton) {
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().signIn()
            DispatchQueue.main.async(execute: { () -> Void in
                button.stopAnimation(animationStyle: .expand, completion: {
                    
                })
            })
        })
    }
    
    @objc fileprivate func btnFacebookLoginAction(_ button: TransitionButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            let loginManager = FBSDKLoginManager()
            loginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if result!.isCancelled {
                    print("FBLogin cancelled")
                } else {
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                    
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        DispatchQueue.main.async(execute: { () -> Void in
                            button.stopAnimation(animationStyle: .expand, completion: {
                                if error == nil {
                                    Utility.getAppDelegate().loadHomeController()
                                } else {
                                    print(error?.localizedDescription)
                                }
                            })
                        })
                    })
                }
            })
        })
    }
    
    @objc fileprivate func btnTwitterLoginAction(_ button: TransitionButton) {
        button.startAnimation() // 2: Then start the animation when the user tap the button
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            
            Twitter.sharedInstance().logIn() { (session, error) in
                if let session = session {
                    let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                    Auth.auth().signIn(with: credential, completion: { (user, error) in
                        DispatchQueue.main.async(execute: { () -> Void in
                            button.stopAnimation(animationStyle: .expand, completion: {
                                if error == nil {
                                    Utility.getAppDelegate().loadHomeController()
                                } else {
                                    print(error?.localizedDescription)
                                }
                            })
                        })
                    })
                } else {
                    print(error?.localizedDescription)
                }
            }
        })
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

