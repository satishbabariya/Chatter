//
//  Configuration.swift
//  Chatter
//
//  Created by Satish on 05/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseDatabase.FIRDatabaseReference
import MessageKit
import Kingfisher

struct ChatRefrences {
    static let conversations = Database.database().reference().child("conversations")
    static let users = Database.database().reference().child("users")
    static let presence = Database.database().reference().child("presence")
    
    static func conversationsList(_ uid : String) -> DatabaseReference{
        return users.child(uid).child("conversationsList")
    }
    
    static func conversationsRef(_ key : String) -> DatabaseReference{
        return conversations.child(key)
    }
    
    static func newConversationsKey() -> String{
        return conversations.childByAutoId().key
    }
}


extension AvatarView {
    func setImageFromURL(url: String) {
        guard let imageURL = URL(string: url) else { return image = #imageLiteral(resourceName: "man") }
        kf.indicatorType = .activity
        kf.setImage(with: imageURL)
    }
}

