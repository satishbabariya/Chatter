//
//  Utils.swift
//  Chatter
//
//  Created by Satish on 04/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import Foundation
import Foundation
import Material
import SwiftMessages
import UIKit

public func navLargeTitles(Controller controller: UIViewController) {
    if #available(iOS 11.0, *) {
        controller.navigationController?.navigationBar.prefersLargeTitles = true
        controller.navigationItem.largeTitleDisplayMode = .always
    }
}

struct ViewLayout {
    
    struct Color {
        static let primary: UIColor = #colorLiteral(red: 0.9171795249, green: 0.9332006574, blue: 0.9371846318, alpha: 1) // #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    }
    
}

struct ButtonLayout {
    struct Flat {
        static let width: CGFloat = 120
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -150
    }
    
    struct Raised {
        static let width: CGFloat = 150
        static let height: CGFloat = 44
        static let offsetY: CGFloat = -75
    }
    
    struct Fab {
        static let diameter: CGFloat = 48
    }
    
    struct Icon {
        static let width: CGFloat = 120
        static let height: CGFloat = 48
        static let offsetY: CGFloat = 75
    }
    
    struct Color {
        static let email: UIColor = #colorLiteral(red: 0.1674376428, green: 0.1674425602, blue: 0.167439878, alpha: 1)
        static let google: UIColor = #colorLiteral(red: 0.9562355876, green: 0.3488204479, blue: 0.2473968267, alpha: 1)
        static let facebook: UIColor = #colorLiteral(red: 0.2840464711, green: 0.4368949533, blue: 0.6755052805, alpha: 1)
        static let twitter: UIColor = #colorLiteral(red: 0.04833548516, green: 0.7077843547, blue: 0.9730156064, alpha: 1)
    }
    
}

class Utility: NSObject {
    
    //  MARK: - UIDevice Methods
    
    class func getDeviceIdentifier() -> String {
        let deviceUUID: String = UIDevice.current.identifierForVendor!.uuidString
        return deviceUUID
    }
    
    //  MARK: - Misc Methods
    
    class func getAppDelegate() -> AppDelegate {
        let appDelegate: UIApplicationDelegate = UIApplication.shared.delegate!
        return appDelegate as! AppDelegate
    }
    
    class func isValidEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    class func isValidPhone(string: String) -> Bool {
        let emailRegEx = "^((\\+)|(00))[0-9]{6,14}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
}
extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(colorImage, for: forState)
    }
}

extension UIViewController {
    
    // MARK: - User Interaction -
    
    func displayCenterMessage(message: String, type: Theme) {
        messageMaker(message: message, position: SwiftMessages.PresentationStyle.center, type: type)
    }
    
    func displayTopMessage(message: String, type: Theme) {
        messageMaker(message: message, position: SwiftMessages.PresentationStyle.top, type: type)
    }
    
    func displayBottomMessage(message: String, type: Theme) {
        messageMaker(message: message, position: SwiftMessages.PresentationStyle.bottom, type: type)
    }
    
    fileprivate func messageMaker(message: String, position: SwiftMessages.PresentationStyle, type: Theme) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .cardView)
        messageView.configureTheme(type)
        messageView.bodyLabel?.text = message
        // messageView.bodyLabel?.isHidden = true
        messageView.button?.isHidden = true
        messageView.titleLabel?.isHidden = true
        // messageView.iconImageView?.isHidden = true
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = position
        config.duration = .seconds(seconds: 2.0)
        SwiftMessages.show(config: config, view: messageView)
    }
    
}
