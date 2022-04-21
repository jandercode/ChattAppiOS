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
    
    func loadChats(){
        
        let chats = realm.objects(Chat.self)
        print(chats)
        print(chats[0].RealmMessagesList)
        
    }
    
}
