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
    @State var chatName : String
    @State var usersInChatMinusCurrent = [String]()
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(Array(firestoreMessageDao.messages.enumerated()), id: \.offset) { index, message in
                        MessageRow(message: message, image: getUserImage(message: message))
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
                            chat.chat_name = firestoreChatDao.createChatName(usersInChat: usersInChat)
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
        
        .navigationBarItems(leading:
                                HStack {
            ProfilePic(size: 30, image: UIImage(imageLiteralResourceName: "profile-pic"))
            Text(chatName)}.padding())
        
    }
    
    
    func getUserImage(message: Message) -> UIImage{
        
        if !UserManager.imageArray.isEmpty{
            for user in FirestoreContactDao.firestoreContactDao.registeredUsers{
                if user.id == message.sender{
                    return UserManager.imageArray[user.id]!
                }
            }
        }
        
        return UIImage(imageLiteralResourceName: "profile-pic")
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(chatId: "", usersInChat: [String](), chatName: "chat name")
    }
}
