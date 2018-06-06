//
//  FirestoreUser.swift
//  Chatter
//
//  Created by Satish on 06/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

extension User {
    public func set() {
        Firestore.firestore()
            .collection("users")
            .document(self.uid)
            .setData([
                "uid": self.uid,
                "displayName": self.displayName as Any,
                "email": self.email as Any,
                "phoneNumber": self.phoneNumber as Any,
                "photoURL": self.photoURL?.absoluteString as Any
            ])
    }
    
    public func set(displayName: String?) {
        Firestore.firestore()
            .collection("users")
            .document(self.uid)
            .setData([
                "uid": self.uid,
                "displayName": displayName as Any,
                "email": self.email as Any,
                "phoneNumber": self.phoneNumber as Any,
                "photoURL": self.photoURL?.absoluteString as Any
            ])
    }
    
}

struct UserProfile: Equatable {
    static func ==(lhs: UserProfile, rhs: UserProfile) -> Bool {
        return lhs.displayName == rhs.displayName &&
            lhs.email == rhs.email &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.photoURL == rhs.photoURL &&
            lhs.uid == rhs.uid
    }
    
    var displayName: String?
    var email: String?
    var phoneNumber: String?
    var photoURL: String?
    var uid: String
}
