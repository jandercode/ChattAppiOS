//
//  FirestoreContactDao.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-07.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class FirestoreUserDao : ObservableObject {
    
    static let firestoreContactDao = FirestoreUserDao()
    
    private init(){}
    
    let db = Firestore.firestore()
    @Published var registeredUsers = [User]()
    
    private let ID_KEY = "id"
    private let USERNAME_KEY = "username"
    private let EMAIL_KEY = "email"
    
    private let USERS_COLLECTION = "users"
    private let FIRST_NAME_KEY = "first_name"
    private let LAST_NAME_KEY = "last_name"
    private let PASSWORD_KEY = "password"
    
    func saveNewUser(user: User){
        
        let newUser : [String : String] = [
            ID_KEY : user.id,
            USERNAME_KEY : user.username,
            FIRST_NAME_KEY : user.firstName,
            LAST_NAME_KEY : user.lastName,
            EMAIL_KEY : user.email,
            PASSWORD_KEY : user.password]
        
        do{
            
            _ = try db.collection(USERS_COLLECTION).document(user.id).setData(from: newUser)
            print("success")
            
        }catch{
            
            print("error saving to DB")
        }
    }
    
    
    func checkLogin(mail: String, password: String){
        
        db.collection(USERS_COLLECTION).whereField(EMAIL_KEY, isEqualTo: mail)
            .getDocuments(){(querysnapshot, err) in
                if let err = err {
                    
                    print("login error: \(err)")
                    
                }else{
                    
                    var data : [String : Any]
                    
                    for doc in querysnapshot!.documents{
                        
                        data = doc.data()
                        
                        if data[self.PASSWORD_KEY] as! String == password{
                            
                            self.setCurrentUsert(data: data)
                            
                        }
                        print("success")
                        
                    }
                    
                    if UserManager.userManager.currentUser == nil{
                        
                        
                        let u = User()
                        u.firstName = "error"
                        u.lastName = "error"
                        u.username = "error"
                        UserManager.userManager.currentUser = u
                        
                        
                        
                    }
                }
            }
    }
    
    func setCurrentUsert(data: [String:Any]){
        
        let user = User()
        user.username = data[self.USERNAME_KEY] as! String
        user.id = data[self.ID_KEY] as! String
        user.firstName = data[self.FIRST_NAME_KEY] as! String
        user.lastName = data[self.LAST_NAME_KEY] as! String
        user.email = data[self.EMAIL_KEY] as! String
        user.password = data[self.PASSWORD_KEY] as! String
        UserManager.userManager.currentUser = user
        
    }
    
    func getUsers(){
        
        self.registeredUsers.removeAll()
        
        db.collection(USERS_COLLECTION).getDocuments(){ querySnapshot, err in
            
            if let e = err{
                print("ERROR \(e)")
            }else{
                self.registeredUsers.removeAll()
                for doc in querySnapshot!.documents{
                    
                    let data = doc.data()
                    let user = User()
                    user.id = data[self.ID_KEY] as! String
                    user.username = data[self.USERNAME_KEY] as! String
                    user.email = data[self.EMAIL_KEY] as! String
                    
                    self.registeredUsers.append(user)
                    
                }
            }
        }
    }
    
    func eraseUsers(){
        
        registeredUsers.removeAll()
        
    }
    
    
    func upadateCurrentUserData(data: String, operation: ActionType){
        
        switch operation{
            
        case .password:
            db.collection(USERS_COLLECTION).document(UserManager.userManager.currentUser!.id).updateData([PASSWORD_KEY : data])
            //UserManager.userManager.currentUser?.password = data
            
        case .email:
            db.collection(USERS_COLLECTION).document(UserManager.userManager.currentUser!.id).updateData([EMAIL_KEY : data])
            //UserManager.userManager.currentUser?.email = data
            
        }
    }
    
    func removeCurrentUser(){
        
        var index = -1
        
        for user in registeredUsers{
            
            print(user.username)
            
        }
        
        for user in registeredUsers{
            
            if user.username == UserManager.userManager.currentUser?.username{
                
                index = registeredUsers.firstIndex(of: user)!
                
            }
            
        }
        
        if index > -1{
            
            self.registeredUsers.remove(at: index)
            
        }
        
        for user in registeredUsers{
            
            print(user.username)
            
        }
        
        
    }
    
    
    
}
