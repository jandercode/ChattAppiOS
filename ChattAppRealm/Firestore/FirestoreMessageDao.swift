//
//  FirestoreMessageDao.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation
import Firebase

class FirestoreMessageDao : ObservableObject {
    let db = Firestore.firestore()
    
    private let ID_KEY = "id"
    private let SENDER_KEY = "sender"
    private let RECEIVER_KEY = "receiver"
    private let TEXT_KEY = "text"
    private let TIMESTAMP_KEY = "timestamp"

    private let MESSAGES_COLLECTION = "messages"
    private let USERS_COLLECTION = "contacts"
    
    func saveMessage() {
        let newMessage = Message()
        
        do {
            try db.collection(USERS_COLLECTION).document(newMessage.receiver).collection(MESSAGES_COLLECTION).document(newMessage.id).setData(from: newMessage)
        } catch {
            print("Error saving newMessage to db")
        }
    }
    
}
