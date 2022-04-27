//
//  UserDao.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-07.
//

import Foundation
import RealmSwift

class RealmUserDao{
    
    var user: [String:String] = [:]
    
    func getUser(){
        
        let realm = try! Realm()
        let users = realm.objects(User.self)
        var userLoginData : [String:String] = [:]
        
        print(users.count)
        
        if !users.isEmpty{
            
            UserManager.userManager.currentUser = users[0]
            print(users[0])
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
        
        let realm = try! Realm()
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
        
        let realm = try! Realm()
        let users = realm.objects(User.self)
        
        try! realm.write({
            realm.delete(users)
        })
        
        
    }
}

