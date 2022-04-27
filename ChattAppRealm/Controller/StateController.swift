//
//  StateController.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-22.
//

import Foundation
import UIKit

// @Main Actor forces it to run on the main thread.
// this class contains the app state variable that controls the view flow, changing what view gets presented based on the value
// that it has. It also stores references to variables thet needs to move between views.

@MainActor class StateController: ObservableObject{
    
    @Published var appState: AppState = .Login
    
    var chatId: String = ""
    var usersInChat: [String] = [String]()
    var chatName: String = ""
    
    var chatRealm : RealmChatDao? = nil
    var messageRealm: RealmMessageDao? = nil
    
    
    func loginLogic(){
        
        self.appState = .Chats
    }
    
    
}
