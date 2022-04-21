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
            
        }else{
            
            userLoginData[UserData.KEY_EMAIL_LOGIN] = nil
            userLoginData[UserData.KEY_PASSWORD_LOGIN] = nil
            
        }
        
        return userLoginData
        
    }
    
    func saveUser(user: User){
        
        let users = realm.objects(User.self)
        
        try! realm.write({
            
            realm.delete(users)
            realm.add(user)
            
        })
        
    }
    
    func eraseUserData(){
        
        let users = realm.objects(User.self)
        
        try! realm.write({
            realm.delete(users)
        })
    }
    
    func updateUserMail(newEmail: String) -> Bool{
        
        let user = realm.objects(User.self).first
        
        if user == nil{
            return false
        }
        
        try! realm.write({
            user?.email = newEmail
        })
        
        return true
        
    }
    
    func updateUserPassword(newPassword: String) -> Bool{
        
        let user = realm.objects(User.self).first
        
        if user == nil{
            return false
        }
        
        try! realm.write({
            user?.password = newPassword
        })
        
        return true
        
    }
    
    
    
}

