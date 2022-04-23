//
//  ContentView.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var showNewChatView = false
    @State var isLoggedIn = false
    @ObservedObject var state : StateController
    
    init() {
        
        state = StateController()
    }
    
    
    let storage = StorageManager()
    
    var body: some View {
        
        switch state.appState {
            
        case .Login:
            LoginView(isLoggedIn: $isLoggedIn, state: state)
        case .Chats:
            ChatsView(isLoggedIn: $isLoggedIn, showNewChatView: $showNewChatView, state: state)
        case .Message:
            MessagesView(state: state ,chatId: state.chatId, usersInChat: state.usersInChat, chatName: state.chatName)
        case .CreateChat:
            NewChatView(state: state)
        default:
            LoginView(isLoggedIn: $isLoggedIn, state: state)
            
        }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
