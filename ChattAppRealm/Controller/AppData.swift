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
    static let KEY_AUTOLOGIN = "remember"
    
}

//methods for saving and reading users loginData
class manageLoginInfo{
    
    static func saveLogin(saveInfo: Bool){
        
        UserData.userDefault.set(saveInfo, forKey: UserData.KEY_AUTOLOGIN)
        
    }
    
    static func loadLogin() -> Bool{
        
        
        let remember = UserData.userDefault.bool(forKey: UserData.KEY_AUTOLOGIN)
        
        return remember
        
    }
}


