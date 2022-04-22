//
//  ManageLoginData.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-21.
//

import Foundation

//methods for saving and reading users loginData
class ManageLoginInfo{
    
    static func saveLogin(saveInfo: Bool){
        
        UserData.userDefault.set(saveInfo, forKey: UserData.KEY_AUTOLOGIN)
        
    }
    
    static func loadLogin() -> Bool{
        
        
        let remember = UserData.userDefault.bool(forKey: UserData.KEY_AUTOLOGIN)
        
        return remember
        
    }
}
