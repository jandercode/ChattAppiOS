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
    let storage = StorageManager()
    
    var body: some View {
        
        if isLoggedIn{
            
            ChatsView(showNewChatView: $showNewChatView)
            
        }else{
            
            LoginView(isLoggedIn: $isLoggedIn)
            
        }
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
