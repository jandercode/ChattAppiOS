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
    var filteredMessages = [Message]()
    
    func saveMessage(message: Message){
        
        try! realm.write({
            realm.add(message)
        })
    }
    
    func saveRecievedMessage(){
        
        let recievedMessages = FirestoreMessageDao.firestoreMessageDao.messages
        
        for message in recievedMessages{
            
            let backup = realm.objects(Message.self).where{
                $0.id == message.id
            }
            
            if backup.isEmpty{
                
                saveMessage(message: message)
            }
        }
    }
    
    func filterMessages(chatId: String){
        
        let filtered = realm.objects(Message.self).where {
            
            $0.referenceChatId == chatId
        }
        
        for message in filtered{
            
            filteredMessages.append(message)
        }
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
