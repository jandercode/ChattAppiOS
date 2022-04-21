//
//  RealmMessageDao.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-21.
//

import Foundation
import RealmSwift

class RealmMessagedao{
    
    let realm = try! Realm()
    
    func saveMessage(message: Message){
        
        try! realm.write({
            realm.add(message)
        })
        
    }
    
    func loadMessage() -> [Message] {
        
        let messages = realm.objects(Message.self)
        var messageArray = [Message]()
        for message in messages{
            messageArray.append(message)
        }
        
        return messageArray
        
    }
    
    func deleteMessage(message: Message){
        
        try! realm.write({
            realm.delete(message)
        })
        
    }
    
    
}
