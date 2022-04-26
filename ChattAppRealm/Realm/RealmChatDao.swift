//
//  RealmChatDao.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-21.
//

import Foundation
import RealmSwift

class RealmChatDao{
    
    let realm = try! Realm()
    var chatsArray = [Chat]()
    
    func saveChat(chat: Chat){
        
        try! realm.write({
            realm.add(chat)
        })
    }
    
    func saveRemoteChats(){
        
        let remoteChats = FirestoreChatDao.firestoreChatDao.chats
        
        for chat in remoteChats{
            
            let backup = realm.objects(Chat.self).where{
                $0.id == chat.id
            }
            
            if backup.isEmpty{
                saveChat(chat: chat)
            }
        }
    }
    
    func loadChats(){
        
        let chats = realm.objects(Chat.self)
        
        for chat in chats{
            chat.users_in_chat = chat.chat_name.components(separatedBy: ", ")
            chatsArray.append(chat)
        }
    }
    
    func deleteChat(chat: Chat){
        
        let chatId = chat.id
        try! realm.write({
            realm.delete(chat)
        })
        
        let messagesToDelete = realm.objects(Message.self).where {
            
            $0.referenceChatId == chatId
        }
        
        try! realm.write({
            realm.delete(messagesToDelete)
        })
    }
    
    func deleteAllChats(){
        
        let chats = realm.objects(Chat.self)
        
        try! realm.write({
            realm.delete(chats)
        })
    }
    
}
