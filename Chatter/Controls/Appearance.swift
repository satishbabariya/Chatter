//
//  Appearance.swift
//  Chatter
//
//  Created by Satish Babariya on 10/19/17.
//  Copyright © 2017 Satish Babariya. All rights reserved.
//

import UIKit
import Material


public func navLargeTitles(Controller controller:UIViewController){
    if #available(iOS 11.0, *) {
        controller.navigationController?.navigationBar.prefersLargeTitles = true
        controller.navigationItem.largeTitleDisplayMode = .always
    }
}

struct ViewLayout {
    
    struct Color {
        static let primary: UIColor = #colorLiteral(red: 0.9171795249, green: 0.9332006574, blue: 0.9371846318, alpha: 1)//#colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
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


