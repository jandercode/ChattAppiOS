//
//  AppData.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-11.
//

import Foundation
import SwiftUI


enum ActionType: Int{
    
    case email = 0, password
    
}

enum AppState: Int{
    
    case Login = 0, Chats, Message, CreateChat, BackupPage, BackupChat
} 

//data for userDefault
enum UserData{
    
    static let userDefault = UserDefaults.standard
    static let KEY_EMAIL_LOGIN = "email"
    static let KEY_PASSWORD_LOGIN = "password"
    static let KEY_AUTOLOGIN = "remember"
    
}

