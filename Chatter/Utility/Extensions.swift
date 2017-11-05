//
//  Extensions.swift
//  Chatter
//
//  Created by Satish Babariya on 10/21/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

extension UIViewController {
    
    // MARK: - User Interaction -
    
    func displayCenterMessage(message : String, type : Theme){
        messageMaker(message: message, position: SwiftMessages.PresentationStyle.center, type: type)
    }
    
    func displayTopMessage(message : String, type : Theme){
        messageMaker(message: message, position: SwiftMessages.PresentationStyle.top, type: type)
    }
    
    func displayBottomMessage(message : String , type : Theme){
        messageMaker(message: message, position: SwiftMessages.PresentationStyle.bottom, type: type)
    }
    
    fileprivate func messageMaker(message : String , position : SwiftMessages.PresentationStyle , type : Theme){
        let messageView : MessageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(type)
        messageView.bodyLabel?.text = message
        //messageView.bodyLabel?.isHidden = true
        messageView.button?.isHidden = true
        messageView.titleLabel?.isHidden = true
        //messageView.iconImageView?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = position
        config.duration = .seconds(seconds: 2.0)
        SwiftMessages.show(config: config, view: messageView)
    }
    
}
