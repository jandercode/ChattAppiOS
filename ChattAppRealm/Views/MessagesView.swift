//
//  MessagesView.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//

import SwiftUI
import Firebase

struct MessagesView: View {
    
    @ObservedObject var state: StateController
    
    let db = Firestore.firestore()
    @ObservedObject var firestoreChatDao = FirestoreChatDao.firestoreChatDao
    @ObservedObject var firestoreMessageDao = FirestoreMessageDao.firestoreMessageDao
    @ObservedObject var userManager = UserManager.userManager
    @ObservedObject var keyboardManager = KeyboardManager()
    @State private var keyboardHeight: CGFloat = 0
    
    @State private var messageText: String = ""
    @State var chatId : String
    @State var usersInChat : [String]
    @State var chatName : String
    @State var isNewDay = true
    
    let chatDao = RealmChatDao()
    let messageDao = RealmMessagedao()
    @State var userImage = UIImage(systemName: "person.circle")
    @State var showUsernames = false
    
    var body: some View {
        VStack {
            
            HStack(alignment:.firstTextBaseline){
                
                Button(action: {
                    state.appState = .Chats
                }, label: {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                })
                    .padding(.leading)
                
                HStack {
                    Button {
                        showUsernames.toggle()
                    } label: {
                        ProfilePic(size: 30, image: userImage!)
                        Text(firestoreChatDao.removeCurrentFromChatName(chatName: chatName))
                            .foregroundColor(Color.black)
                            .lineLimit(1)
                    }
                  // ProfilePic(size: 30, image: UIImage(systemName: "person.circle")!)
                    
                }.padding()
                    Spacer()
                
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(Array(firestoreMessageDao.messages.enumerated()), id: \.offset) { index, message in
                        if index >= 1 {
                            if !Calendar.current.isDate(firestoreMessageDao.messages[index].timestamp ?? Date(), inSameDayAs: firestoreMessageDao.messages[index-1].timestamp ?? Date()) {
                                DateRow(timestamp: message.timestamp ?? Date())
                            }
                        } else {
                            DateRow(timestamp: message.timestamp ?? Date())
                        }
                        
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
                .onTapGesture {
                    self.endTextEditing()
                }
            }
            .sheet(isPresented: $showUsernames) {
                ShowUsernames(chatName: firestoreChatDao.removeCurrentFromChatName(chatName: chatName))
            }
            
            HStack {
                TextField("Aa", text: $messageText)
                Button {
                    // create a new chat in firestore if it doesn't already exist
                    
                    if messageText != "" {
                        if chatId == "" {
                            let chat = Chat()
                            chatId = chat.id
                            chat.users_in_chat = usersInChat
                            chat.chat_name = firestoreChatDao.createChatName(usersInChat: usersInChat)
                            firestoreChatDao.saveNewChat(chat: chat)
                            chatDao.saveChat(chat: chat)
                            
                        }
                        // add new message to firestore
                        let sender = UserManager.userManager.currentUser?.id ?? "anonymous"
                        let message = Message()
                        message.sender = sender
                        message.text = messageText
                        message.timestamp = Date()
                        message.referenceChatId = chatId
                        
                        firestoreMessageDao.saveMessage(message: message, chatId: chatId)
                        messageDao.saveMessage(message: message)
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
//                imageChangeQueue {
//                    changeUserImage()
//                }

            }
        }
    }
    

    
    func getUserImage(message: Message) -> UIImage{
        
        if !userManager.imageArray.isEmpty{
            for user in FirestoreContactDao.firestoreContactDao.registeredUsers{
                if user.id == message.sender{
                    return userManager.imageArray[user.id]!
                }
            }
        }
        
        return UIImage(systemName: "person.circle")!
        
    }

}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView(chatId: "", usersInChat: [String](), chatName: "chat name")
//    }
//}
