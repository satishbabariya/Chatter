//
//  MessageViewController.swift
//  Chatter
//
//  Created by Satish on 04/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import MapKit
import MessageKit
import UIKit

class ConversationViewController: MessagesViewController {
    
    var messageList: [Message] = []
    var currentUser: User!
    
    fileprivate var conversationReference: DatabaseReference!
    fileprivate var recipientsUid: String!
    
    fileprivate var recipient: UserProfile!
    
    convenience init(Refrence ref: DatabaseReference, Receipent uid: String) {
        self.init()
        self.conversationReference = ref
        self.recipientsUid = uid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        if let currentUser = Auth.auth().currentUser,
            self.conversationReference != nil || self.recipientsUid != nil {
            self.currentUser = currentUser
        } else {
            self.dismiss(animated: true)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, handler: { [weak self] in
            if self == nil {
                return
            }
            self!.dismiss(animated: true)
        })
        self.getRecepientInfo()
        self.observeMessages()
    }
    
    fileprivate func observeMessages() {
        self.conversationReference.queryOrderedByKey().observe(.childAdded) { [weak self] snapshot in
            if self == nil { return }
            if snapshot.exists() {
                guard let messge = Message(snapshot: snapshot) else { return }
                
                // Read Message
                if self!.recipientsUid != "" && self!.currentUser.uid != messge.sender.id {
                    self?.conversationReference.child(messge.messageId).child("isRead").setValue(true)
                }
                self!.messageList.append(messge)
                self!.messagesCollectionView.reloadData()
                self!.messagesCollectionView.scrollToBottom()
            }
        }
        
    }
    
    fileprivate func getRecepientInfo() {
        Firestore.firestore().collection("users").document(self.recipientsUid).getDocument { [weak self] snapshot, _ in
            if self == nil { return }
            
            if let snapshot = snapshot, snapshot.exists, let item = snapshot.data(), let uid: String = item["uid"] as? String {
                var profile: UserProfile = UserProfile(displayName: nil, email: nil, phoneNumber: nil, photoURL: nil, uid: uid)
                if let displayName: String = item["displayName"] as? String {
                    profile.displayName = displayName
                    self?.title = displayName
                }
                
                if let email: String = item["email"] as? String {
                    profile.email = email
                }
                
                if let phoneNumber: String = item["phoneNumber"] as? String {
                    profile.phoneNumber = phoneNumber
                }
                
                if let photoURL: String = item["photoURL"] as? String {
                    profile.photoURL = photoURL
                }
                self?.recipient = profile
            } else {
                self?.dismiss(animated: true)
            }
        }
    }
    
}

extension ConversationViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        self.sendMessage(Message: Message(text: text, sender: Sender(id: self.currentUser.uid, displayName: self.currentUser.displayName ?? "No Name"), messageId: UUID().uuidString, date: Date()))
        inputBar.inputTextView.text = String()
    }
    
    fileprivate func sendMessage(Message message: Message) {
        var dict: [String: Any] = message.dictionary
        dict["isRead"] = false
        dict["receiver"] = ["id": recipientsUid, "displayName": recipient.displayName ?? ""]
        conversationReference.childByAutoId().setValue(dict)
    }
    
}

// MARK: - MessagesDataSource

extension ConversationViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: self.currentUser.uid, displayName: self.currentUser.displayName ?? "No Name")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.messageList[indexPath.section]
    }
    
}

extension ConversationViewController: MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return MessageStyle.none
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
}
