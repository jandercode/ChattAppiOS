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
    var allMessages = [Message]()
    
    func saveMessage(message: Message){
        
        try! realm.write({
            realm.add(message)
        })
    }
    
    func loadMessage(){
        
        let messages = realm.objects(Message.self)
        for message in messages{
            
            allMessages.append(message)
        }
        
    }
    
    func deleteMessage(message: Message){
        
        try! realm.write({
            realm.delete(message)
        })
        
    }
    
    
}
