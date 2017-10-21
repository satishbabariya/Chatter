//
//  Utility.swift
//  Chatter
//
//  Created by Satish Babariya on 10/19/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import UIKit

class Utility: NSObject {
    
    //  MARK: - UIDevice Methods
    
    class func getDeviceIdentifier()->String{
        let deviceUUID: String = UIDevice.current.identifierForVendor!.uuidString
        return deviceUUID
    }
    
    //  MARK: - Misc Methods
    
    class func getAppDelegate()->AppDelegate{
        let appDelegate: UIApplicationDelegate = UIApplication.shared.delegate!
        return appDelegate as! AppDelegate
    }
    
    class func isValidEmail(string: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }
    
    class func isValidPhone(string: String) -> Bool {
        let emailRegEx = "^((\\+)|(00))[0-9]{6,14}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: string)
    }



}
