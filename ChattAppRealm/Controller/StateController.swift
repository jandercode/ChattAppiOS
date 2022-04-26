//
//  StateController.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-22.
//

import Foundation
import UIKit

@MainActor class StateController: ObservableObject{
    
    //static let stateController = StateController()
    @Published var appState: AppState = .Login
    
    var chatId: String = ""
    var usersInChat: [String] = [String]()
    var chatName: String = ""
    
    func loginLogic(){
        
        self.appState = .Chats
    }
    
    
}
