//
//  RealmMessageDao.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-21.
//

import Foundation
import RealmSwift

class RealmMessageDao{
    
    let realm = try! Realm()
    var allMessages = [Message]()
    
    func saveMessage(message: Message){
        
        try! realm.write({
            realm.add(message)
        })
    }
    
    func saveRecievedMessage(){
        
        //let recievedMessages = FirestoreMessageDao.firestoreMessageDao.messages
        
//        for message in recievedMessages{
//            let backup == 
//        }
        
    }
    
    func loadMessages(){
        
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
