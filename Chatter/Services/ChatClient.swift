//
//  ChatClient.swift
//  Chatter
//
//  Created by Satish on 05/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import Firebase
import Foundation
import RxFirebase
import RxSwift
// import MessageKit
import FirebaseDatabase.FIRDatabaseReference

class ChatClient: NSObject {
    
    // MARK: - Attribute -
    fileprivate var currentUser: User!
    fileprivate var recipientsUid: String!
    
    // conversations Refrences
    fileprivate var currentUserRef: DatabaseReference!
    fileprivate var recepientUserRef: DatabaseReference!
    
    // MARK: - Lifecycle -
    
    init?(Recipient uid: String) {
        super.init()
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        self.currentUser = currentUser
        recipientsUid = uid
        currentUserRef = ChatRefrences.conversationsList(currentUser.uid).child(uid)
        recepientUserRef = ChatRefrences.conversationsList(uid).child(currentUser.uid)
    }
    
    // MARK: - Public Interface -
    
    /// By using this method you can get single conversation refence.
    ///
    /// - Returns: Single Observer of DatabaseRefrence
    func getReference() -> Observable<DatabaseReference> {
        return Observable.create { observer in
            self.currentUserRef
                .rx
                .observeSingleEvent(DataEventType.value)
                .subscribe({ event in
                    switch event {
                    case .next(let snapshot):
                        if snapshot.exists(),
                            let key: String = snapshot.value as? String {
                            observer.onNext(ChatRefrences.conversationsRef(key))
                        } else {
                            let key: String = ChatRefrences.newConversationsKey()
                            self.currentUserRef.setValue(key)
                            self.recepientUserRef.setValue(key)
                            observer.onNext(ChatRefrences.conversationsRef(key))
                        }
                    case .error(let error):
                        observer.onError(error)
                    case .completed:
                        observer.onCompleted()
                    }
                })
//            return Disposables.create()
        }
    }
    
}
