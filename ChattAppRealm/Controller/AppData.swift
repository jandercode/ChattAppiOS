//
//  AppData.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-11.
//

import Foundation
import SwiftUI


enum ActionType: Int{
    
    case email = 0, userName
    
}

//data for userDefault
enum UserData{
    
    static let userDefault = UserDefaults.standard
    static let KEY_EMAIL_LOGIN = "email"
    static let KEY_PASSWORD_LOGIN = "password"
    
}

//methods for saving and reading users loginData
class manageLoginInfo{
    
    static func saveLogin(mail: String, password: String){
        
        UserData.userDefault.set(mail, forKey: UserData.KEY_EMAIL_LOGIN)
        UserData.userDefault.set(password, forKey: UserData.KEY_PASSWORD_LOGIN)
        
    }
    
    static func loadLogin() -> [String: String]{
        
        var loginData: [String : String] = [:]
        
        let mail = UserData.userDefault.string(forKey: UserData.KEY_EMAIL_LOGIN)
        let password = UserData.userDefault.string(forKey: UserData.KEY_PASSWORD_LOGIN)
        
        if mail != nil && password != nil{
            
            loginData[UserData.KEY_EMAIL_LOGIN] = mail
            loginData[UserData.KEY_PASSWORD_LOGIN] = password
            
        }
        
        return loginData
        
    }
}

//SINGLETON
class UserManager: ObservableObject{
    
    static let userManager = UserManager()
    @Published var currentUser: User? = nil
    var userImage: UIImage? = nil
    @Published var imageArray : [String:UIImage] = [:]
    
    private init(){
        loadStandardProfilePicture()
    }
    
    func loadStandardProfilePicture(){
        
        for user in FirestoreContactDao.firestoreContactDao.registeredUsers{
            
            imageArray[user.id] = UIImage(systemName: "person.circle")
            
        }
        
    }
    
    
    
}
