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
    
    func saveChat(chat: Chat){
        
        try! realm.write({
            realm.add(chat)
        })
        
    }
    
    func loadChats() -> [Chat]{
        
        let chats = realm.objects(Chat.self)
        var chatsArray = [Chat]()
        
        for chat in chats{
            chatsArray.append(chat)
        }
        
        return chatsArray
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
    
}
