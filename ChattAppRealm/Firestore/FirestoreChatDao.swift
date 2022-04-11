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
    
    private init(){}
    
    let db = Firestore.firestore()
    @Published var chats = [Chat]()
    
    private let CHATS_COLLECTION = "chats"
    private let USERS_IN_CHAT_KEY = "users_in_chat"
    private let ID_KEY = "id"
    
    func updateUsersInChatList(existingUserList: [String], usersToAddToList: [String]) -> [String] {
        var usersInChatList = [String]()
        for userInList in existingUserList {
            usersInChatList.append(userInList)
        }
        for userToAdd in usersToAddToList {
            usersInChatList.append(userToAdd)
        }
        print(usersInChatList)
        return usersInChatList
    }
    
    func saveNewChat(chat: Chat){
                
        let newChat : [String : Any] = [
            ID_KEY : chat.id,
            USERS_IN_CHAT_KEY : chat.users_in_chat]
        
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
