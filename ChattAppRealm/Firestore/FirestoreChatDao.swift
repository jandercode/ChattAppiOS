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
    @Published var chatName = ""
    
    var listener: ListenerRegistration? = nil
    
    private let CHATS_COLLECTION = "chats"
    private let USERS_IN_CHAT_KEY = "users_in_chat"
    private let ID_KEY = "id"
    private let CHAT_NAME_KEY = "chat_name"
    
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
    
    func createChatName(usersInChat: [String]) -> String {
        var chatNameArray = [String]()
        
        chatNameArray.append(UserManager.userManager.currentUser?.username ?? "current user")
        for user in FirestoreContactDao.firestoreContactDao.registeredUsers {
            for userId in usersInChat {
                if user.id == userId {
                    chatNameArray.append(user.username)
                }
            }
        }
        
        chatName = chatNameArray.joined(separator: ", ")
        return chatName
    }
    
    func removeCurrentFromChatName(chatName: String) -> String {
        var chatNameMinusCurrent = chatName.replacingOccurrences(of: "\(UserManager.userManager.currentUser?.username ?? "")", with: "")
        if chatNameMinusCurrent.hasSuffix(", ") {
            chatNameMinusCurrent.removeLast(2)
        }
        if chatNameMinusCurrent.hasPrefix(", ") {
            chatNameMinusCurrent.removeFirst(2)
        }
        if chatNameMinusCurrent.contains(", , ") {
            chatNameMinusCurrent = chatNameMinusCurrent.replacingOccurrences(of: ", , ", with: ", ")
        }
        return chatNameMinusCurrent
    }
    
    func saveNewChat(chat: Chat){
        
        let newChat : [String : Any] = [
            ID_KEY : chat.id,
            USERS_IN_CHAT_KEY : chat.users_in_chat,
            CHAT_NAME_KEY : chat.chat_name]
        
        db.collection(CHATS_COLLECTION).document(chat.id).setData(newChat)
        
    }
    
    func deleteChat(at indexSet: IndexSet) {
        for index in indexSet {
            let chat = chats[index]
            db.collection(CHATS_COLLECTION).document(chat.id).delete()
        }
    }
    
    func checkIfExists(chatId: String) -> Bool{
        
        for chat in chats{
            
            if chat.id == chatId{
                return true
            }
        }
        
        return false
    }
    
    func listenToFirestore() {
        
        listener = db.collection(CHATS_COLLECTION).whereField("users_in_chat", arrayContains: "\(UserManager.userManager.currentUser?.id ?? User().id)" ).order(by: "timestamp", descending: true).addSnapshotListener { snapshot, err in
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
    
    func removeChatListener(){
        
        listener?.remove()
        
    }
    
    
    
    
}
