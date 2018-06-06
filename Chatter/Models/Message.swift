//
//  Message.swift
//  Chatter
//
//  Created by Satish on 04/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import CoreLocation.CLLocation
import FirebaseDatabase.FIRDatabaseReference
import Foundation
import MessageKit

struct Message: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var kind: MessageKind
    
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = MockMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = MockMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(location: CLLocation, sender: Sender, messageId: String, date: Date) {
        let locationItem = MockLocationItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(emoji: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
    
    var dictionary: [String: Any] {
        return [
            // "messageId": self.messageId,
            "sentDate": ServerValue.timestamp(),
            "sender": ["id": self.sender.id,
                       "displayName": self.sender.displayName // ,
                       // "image": sender.image
                
            ],
            "data": getData()
        ]
    }
    
    fileprivate func getData() -> [String: Any] {
        switch self.kind {
        case .text(let text):
            return ["text": text.trimmed]
        case .attributedText(let text):
            return ["attributedText": text]
        case .photo(let mediaItem):
            return ["photo": mediaItem.url ?? ""]
        case .video(let mediaItem):
            return ["video": mediaItem.url ?? ""]
        case .location(let locationItem):
            return ["location": String(locationItem.location.coordinate.latitude) + ":" + String(locationItem.location.coordinate.longitude)]
        case .emoji(let string):
            return ["emoji": string]
        case .custom:
            return ["text": ""]
        }
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else { return nil }
        if
            let sentDate: Int = dict["sentDate"] as? Int,
            let dictSender: [String: String] = dict["sender"] as? [String: String],
            let dictData: [String: Any] = dict["data"] as? [String: Any] {
            self.messageId = snapshot.key
            self.sentDate = Date(timeIntervalSince1970: TimeInterval(TimeInterval(sentDate / 1000)))
            self.sender = Sender(id: dictSender["id"] ?? "", displayName: dictSender["displayName"] ?? "")
            
            if let text: String = dictData["text"] as? String {
                self.kind = MessageKind.text(text.trimmed)
            } else if let image: String = dictData["photo"] as? String, let url: URL = URL(string: image) {
                self.kind = MessageKind.photo(MockMediaItem(url: url))
            } else if let video: String = dictData["video"] as? String, let url: URL = URL(string: video) {
                self.kind = MessageKind.photo(MockMediaItem(url: url))
            } else if let location: String = dictData["location"] as? String,
                location.components(separatedBy: ":").count == 2,
                let first: String = location.components(separatedBy: ":").first,
                let last: String = location.components(separatedBy: ":").last,
                let latitude: CLLocationDegrees = CLLocationDegrees(first),
                let longitude: CLLocationDegrees = CLLocationDegrees(last) {
                self.kind = MessageKind.location(MockLocationItem(location: CLLocation(latitude: latitude, longitude: longitude)))
            } else {
                return nil
            }
            
        } else {
            return nil
        }
    }
    
}

private struct MockLocationItem: LocationItem {
    
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
    
}

private struct MockMediaItem: MediaItem {
    var image: UIImage?
    var placeholderImage: UIImage
    var url: URL?
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
    
}
