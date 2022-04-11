//
//  FirestoreChatDao.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-08.
//

import Foundation
import Firebase

class FirestoreChatDao : ObservableObject {
    static let firestoreChatDao = FirestoreChatDao()
    let db = Firestore.firestore()
    @Published var chats = [Chat]()
    
    private let CHATS_COLLECTION = "chats"
    private let USERS_IN_CHAT_KEY = "users_in_chat"
    private let ID_KEY = "id"
    
    func saveNewChat(chat: Chat){
                
        let newChat : [String : Any] = [
            ID_KEY : chat.id,
            USERS_IN_CHAT_KEY : chat.usersInChat]
        
        do{
            _ = try db.collection(CHATS_COLLECTION).document(chat.id).setData(newChat)
            print("success")
            
        }catch{
            
            print("error saving to DB")
        }
    }
    
    func deleteChat(at indexSet: IndexSet) {
        for index in indexSet {
            let chat = chats[index]
            db.collection(CHATS_COLLECTION).document(chat.id).delete()
        }
    }

    func listenToFirestore() {
        db.collection(CHATS_COLLECTION).addSnapshotListener { snapshot, err in
            guard let snapshot = snapshot else { return }
            if let err = err {
                print("Error getting document \(err)")
            } else {
                self.chats.removeAll()
                for document in snapshot.documents {
                    let result = Result {
                        try document.data(as: Chat.self)
                    }
                    switch result {
                    case .success(let chat) :
                        self.chats.append(chat)
                    case .failure(let error) :
                        print("Error decoding item: \(error)")
                    }
                }
            }
        }
    }
}
