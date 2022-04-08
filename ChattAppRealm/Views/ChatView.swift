//
//  MessagesView.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//

import SwiftUI
import Firebase

struct ChatView: View {
    let db = Firestore.firestore()
    @ObservedObject var firestoreChatDao = FirestoreChatDao()
    
    @State private var messageText: String = ""
    
    var body: some View {
        VStack {
            List {
                Text("hello")
                Text("hey! how are you?")
                Text("pretty good thanks")
            }
            HStack {
                TextField("Aa", text: $messageText)
                Button {
                    // create a new chat in firestore if it doesn't already exist
                    var chat = Chat()
                    chat.usersInChat = ["Billy", "Dave"]
                    firestoreChatDao.saveNewChat(chat: chat)
                    // TODO: add new message to firestore
                    
                } label: {
                    Text("Send")
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
