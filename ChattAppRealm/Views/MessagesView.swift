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
    
    @ObservedObject var firestoreChatDao = FirestoreChatDao.firestoreChatDao
    @ObservedObject var firestoreMessageDao = FirestoreMessageDao.firestoreMessageDao
    @ObservedObject var keyboardManager = KeyboardManager()
    
    @State private var messageText: String = ""
    @State var chatId : String
    @State var usersInChat : [String]
    @State var chatName : String
    
    let chatDao = RealmChatDao()
    let messageDao = RealmMessageDao()
    let storage = StorageManager()
    
    @State var showUsernames = false
    
    @State var newChat : Chat? = nil
    
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

                        ProfilePic(size: 30, images: storage.getProfilePics(usersInChatList: usersInChat) )
                        Text(firestoreChatDao.removeCurrentFromChatName(chatName: chatName))
                            .foregroundColor(Color.black)
                            .lineLimit(1)
                    }
                    
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
                        
                        MessageRow(message: message, image: getUserImage(message: message), usersInChat: usersInChat)
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
                ShowUsernamesSheet(chatName: firestoreChatDao.removeCurrentFromChatName(chatName: chatName), profilePicArray: getProfilePic(usersInChatList: usersInChat))
            }
            
            HStack {
                TextField("Aa", text: $messageText)
                Button {
                    // create a new chat in firestore if it doesn't already exist
                    if !firestoreChatDao.checkIfExists(chatId: chatId){
                        firestoreChatDao.saveNewChat(chat: newChat!)
                    }
                    
                    if messageText != "" {
                        
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
                
                if chatId == "" {
                    
                    let chat = Chat()
                    chatId = chat.id
                    chat.users_in_chat = usersInChat
                    chat.chat_name = firestoreChatDao.createChatName(usersInChat: usersInChat)
                    chatDao.saveChat(chat: chat)
                    newChat = chat
                    
                }
                
                firestoreMessageDao.messages.removeAll()
                firestoreMessageDao.listenToFirestore(chatId: chatId)
                
            }
            
        }.onDisappear{
            
            messageDao.saveRecievedMessage()
            firestoreMessageDao.stopListen()
        }
    }
    
    func getUserImage(message: Message) -> UIImage{
        
        var img: UIImage
        
        if !UserManager.userManager.imageArray.isEmpty{
            for user in FirestoreUserDao.firestoreContactDao.registeredUsers{
                if user.id == message.sender{
                    img = UserManager.userManager.imageArray[user.id] ?? UIImage(systemName: "person.circle")!
                    return img
                }
            }
        }
        
        return UIImage(systemName: "person.circle")!
        
    }
    
    func getProfilePic(usersInChatList: [String]) -> [UIImage] {
        var usersInChatMinusCurrent = usersInChatList
        
        var index = -1
        for user in usersInChatMinusCurrent {
            if user == UserManager.userManager.currentUser?.id {
                index = usersInChatMinusCurrent.firstIndex(of: user)!
            }
        }
        
        if index > -1 {
            usersInChatMinusCurrent.remove(at: index)
        }
        
        var profilePicArray = [UIImage]()
        for userId in usersInChatMinusCurrent {
            profilePicArray.append(UserManager.userManager.imageArray[userId] ?? UIImage(systemName: "person.circle")!)
        }
        return profilePicArray
        
    }
}

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
