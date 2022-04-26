//
//  FirestoreMessageDao.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation
import Firebase

struct MessageData {
    var text: String
}
class FirestoreMessageDao : ObservableObject {
    static let firestoreMessageDao = FirestoreMessageDao()
    
    private init(){}
    
    let db = Firestore.firestore()
    @Published var messages = [Message]()
    @Published var isNewDay = true
    var snapshotWoo : ListenerRegistration? = nil
    
    private let ID_KEY = "id"
    private let SENDER_KEY = "sender"
    private let TEXT_KEY = "text"
    private let TIMESTAMP_KEY = "timestamp"
    
    private let MESSAGES_COLLECTION = "messages"
    private let CHATS_COLLECTION = "chats"
    
    
    
    func saveMessage(message: Message, chatId : String) {
        
        do {
            try db.collection(CHATS_COLLECTION).document(chatId).collection(MESSAGES_COLLECTION).document(message.id).setData(from: message)
            db.collection(CHATS_COLLECTION).document(chatId).setData([ "last_message": message.text ], merge: true)
            db.collection(CHATS_COLLECTION).document(chatId).setData([ "timestamp": message.timestamp ?? Date() ], merge: true)
            messages.removeAll()
            
        } catch{
            
            print("Error saving newMessage to db")
        }
        
    }
    
    func listenToFirestore(chatId : String) {
        if chatId != "" {
            snapshotWoo = db.collection(CHATS_COLLECTION).document(chatId).collection(MESSAGES_COLLECTION).order(by: "timestamp", descending: false).addSnapshotListener { snapshot, err in
                
                guard let snapshot = snapshot else {return}
                
                if let err = err {
                    print("Error getting document \(err)")
                } else {
                    self.messages.removeAll()
                    for document in snapshot.documents {
                        let result = Result {
                            try document.data(as: Message.self)
                        }
                        switch result {
                        case .success(let message) :
                            self.messages.append(message)
                        case .failure(let error) :
                            print("Error decoding item: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func stopListen() {
        snapshotWoo?.remove()
    }
}
