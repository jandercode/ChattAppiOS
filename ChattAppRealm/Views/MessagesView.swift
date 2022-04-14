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
    @ObservedObject var keyboardManager = KeyboardManager()
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var messageText: String = ""
    @State var chatId : String
    @State var usersInChat : [String]
    @State var chatName : String = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(Array(firestoreMessageDao.messages.enumerated()), id: \.offset) { index, message in
                        MessageRow(message: message)
                            .id(index)
                    }
                }
                .onAppear {
                    proxy.scrollTo(firestoreMessageDao.messages.count - 1, anchor: .bottom)
                }
                .onChange(of: firestoreMessageDao.messages.count) { newValue in
                    proxy.scrollTo(firestoreMessageDao.messages.count - 1, anchor: .bottom)
                }
                .onChange(of: keyboardManager.isVisible, perform: { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo(firestoreMessageDao.messages.count - 1, anchor: .bottom)
                        }
                        keyboardManager.isVisible = false
                    }
                })
            }
            
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
                usersInChat.remove(at: 0)
                chatName = usersInChat.joined(separator: ", ")
                print(chatName)
                firestoreMessageDao.messages.removeAll()
                firestoreMessageDao.listenToFirestore(chatId: chatId)
            }
        }
        
//        .padding(.bottom, keyboardManager.keyboardHeight)
//        .edgesIgnoringSafeArea(keyboardManager.isVisible ? .bottom : [])
       // .padding(.bottom, keyboardHeight)
        .navigationBarItems(leading:
                                HStack {
            ProfilePic(size: 30)
            Text(chatName)}.padding())
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(chatId: "", usersInChat: [String]())
    }
}
