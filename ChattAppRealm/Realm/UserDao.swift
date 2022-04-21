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
    
    func getUser() -> [String: String]{
        
        let users = realm.objects(User.self)
        var userLoginData : [String:String] = [:]
        
        if !users.isEmpty{
            
            userLoginData[UserData.KEY_EMAIL_LOGIN] = users[0].email
            userLoginData[UserData.KEY_PASSWORD_LOGIN] = users[0].password
            
        }
        
        return userLoginData
        
    }
    
    func saveUser(user: User){
        
        try! realm.write({
            
            realm.add(user)
            
        })
        
        
    }
    
    
    
}

