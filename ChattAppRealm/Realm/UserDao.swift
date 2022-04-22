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
    var user: [String:String] = [:]
    
    func getUser(){
        
        let users = realm.objects(User.self)
        var userLoginData : [String:String] = [:]
        
        if !users.isEmpty{
            
            userLoginData[UserData.KEY_EMAIL_LOGIN] = users[0].email
            userLoginData[UserData.KEY_PASSWORD_LOGIN] = users[0].password
            
        }else{
            
            userLoginData[UserData.KEY_EMAIL_LOGIN] = nil
            userLoginData[UserData.KEY_PASSWORD_LOGIN] = nil
            
        }
        
        user = userLoginData
        print(user)
        
    }
    
    func saveUser(newUser: User){
        
        let user = realm.objects(User.self).where{
            $0.id == newUser.id
        }.first
        
        if user == nil{
                        
            try! realm.write({
                
                realm.add(newUser)
                
            })
        }

    }
    
    func eraseUserData(){
        
        let users = realm.objects(User.self)
                    
            try! realm.write({
                realm.delete(users)
            })
            
        
    }
}

