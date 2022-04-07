//
//  UserDao.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-07.
//

import Foundation
import RealmSwift

class UserDao{
    
    let realm = try! Realm()
    
    func getUser(userName: String, password: String) -> Bool{
        
        let users = realm.objects(User.self)
        
        if !users.isEmpty{
            
            for user in users{
                
                if user.username == userName && user.password == password{
                    
                    return true
                    
                }
                
            }
            
        }
        
        return false
        
    }
    
    func saveUser(user: User){
        
        try! realm.write({
            
            realm.add(user)
            
        })
        
        
    }
    
    
    
}

