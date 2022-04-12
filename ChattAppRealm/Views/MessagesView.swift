//
//  MessagesView.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//

import SwiftUI
import Firebase

struct MessagesView: View {
    let db = Firestore.firestore()
    @ObservedObject var firestoreChatDao = FirestoreChatDao.firestoreChatDao
    @ObservedObject var firestoreMessageDao = FirestoreMessageDao.firestoreMessageDao
    
    @State private var messageText: String = ""
    @State var chatId : String
    @State var usersInChat : [String]
    
    var body: some View {
        VStack {
            List {
                ForEach(firestoreMessageDao.messages) { message in
                    MessageRow(message: message)
                        .listRowSeparator(.hidden)
                        
//                    Text(message.text)
//                        .padding(10)
//                        .background(message.sender == UserManager.userManager.currentUser?.id ? Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)) : Color.blue)
//                        .cornerRadius(10)
                }
            }.listStyle(.plain)
            
            HStack {
                TextField("Aa", text: $messageText)
                Button {
                    // create a new chat in firestore if it doesn't already exist
                    
                    if messageText != "" {
                        if chatId == "" {
                            var chat = Chat()
                            chatId = chat.id
                            chat.users_in_chat = usersInChat
                            firestoreChatDao.saveNewChat(chat: chat)
                        }
                        // add new message to firestore
                        let sender = UserManager.userManager.currentUser?.id ?? "anonymous"
                        let message = Message(sender: sender, text: messageText)
                        
                        firestoreMessageDao.saveMessage(message: message, chatId: chatId)
                        messageText = ""
                        firestoreMessageDao.listenToFirestore(chatId: chatId)
                    }
                } label: {
                    Text("Send")
                }
            }
            .padding()
            .onAppear {
                firestoreMessageDao.messages.removeAll()
                firestoreMessageDao.listenToFirestore(chatId: chatId)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(chatId: "", usersInChat: [String]())
    }
}