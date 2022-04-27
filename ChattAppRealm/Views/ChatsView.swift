//
//  ChatsView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-07.
//

import SwiftUI

struct ChatsView: View{
    
    @Binding var isLoggedIn: Bool
    @Binding var showNewChatView: Bool
    
    @ObservedObject var firestoreChatDao = FirestoreChatDao.firestoreChatDao
    @ObservedObject var state: StateController
    
    let userManager = UserManager.userManager
    @State private var showChatView = false
    @State var usersInChat = [String]()
    @State var chatId = ""
    @State var chatName = ""
    @State var chatNameMinusCurrent = ""
    @State var presentUserInfo = false
    @State var userImage = UIImage(systemName: "person.circle")
    @State var imageChanged = false
    @State var isConnected = false
    
    let storage = StorageManager()
    let userDao = UserDao()
    let realmMessage = RealmMessageDao()
    let realmChat = RealmChatDao()
    
    @State private var error: ErrorInfo?
    
    
    var body: some View{
        
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                HStack{
                    Text("Chats")
                        .font(.largeTitle)
                        .padding()
                    Button {
                        presentUserInfo.toggle()
                    } label: {
                        ProfilePic(size: 30, images: [userImage!])
                    }.padding()
                }
                .padding(.top, 40)
                List{
                    
                    ForEach(firestoreChatDao.chats) { chat in
                        
                        ChatRow(chat: chat, chatName: firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), profilePic: storage.getProfilePics(usersInChatList: chat.users_in_chat))
                        
                            .listRowSeparator(.hidden)
                        
                            .onTapGesture {
                                
                                state.usersInChat = chat.users_in_chat
                                state.chatId = chat.id
                                state.chatName = chat.chat_name
                                state.appState = .Message
                                print(usersInChat)
                            }
                        
                    }.onDelete(perform: firestoreChatDao.deleteChat(at:))
                    
                }.refreshable{
                    
                    do{
                        try await storage.reload()
                    }catch{
                        let _ = error
                    }
                }
                
                .listStyle(.plain)
                
                Spacer()
                
            }.sheet(isPresented: $presentUserInfo, content: {
                UserInfoView(storage: storage, imageChanged: $imageChanged, state: state)
                
            }).onDisappear(){
                if imageChanged{
                    changeUserImage()
                }
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        
                        if isConnected{
                            
                            state.appState = .CreateChat
                            
                        }else{
                            
                            error = ErrorInfo(id: 1, title: "Not Connected", description: "You can't create a new chat when you are not connected to internet")
                        }
                        
                    } label: {
                        
                        ZStack {
                            
                            Circle()
                                .fill(.green)
                                .frame(width: 50)
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                        }
                        .frame(height: 50)
                        
                    }.alert(item: $error, content: { error in
                        
                        Alert(
                            
                            title: Text(error.title),
                            message: Text(error.description)
                        )
                    })
                    .padding(.trailing, 30)
                }
            }
            .sheet(isPresented: $presentUserInfo, content: {
                UserInfoView(storage: storage, imageChanged: $imageChanged, state: state)
            }).onDisappear(){
                if imageChanged{
                    changeUserImage()
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        state.appState = .CreateChat
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.green)
                                .frame(width: 50)
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                        }
                        .frame(height: 50)
                    }.padding(.trailing, 30)
                }
            }.onAppear{
                
                if Reachability.isConnectedToNetwork(){
                    isConnected = true
                } else {
                    isConnected = false
                }
                
                if ManageLoginInfo.loadLogin(){
                    
                    userDao.saveUser(newUser: userManager.currentUser!)
                    ManageLoginInfo.saveLogin(saveInfo: true)
                }
                imageChangeQueue {
                    changeUserImage()
                }
                
                //Firestore
                firestoreChatDao.listenToFirestore()
                FirestoreContactDao.firestoreContactDao.removeCurrentUser()
                
                //Storage
                storage.loadImageFromStorage(id: UserManager.userManager.currentUser!.id)                
                
                //Realm
                realmChat.loadChats()
                realmMessage.loadMessages()
                
                state.chatRealm = realmChat
                state.messageRealm = realmMessage
                
            }
            .onDisappear{
                
                firestoreChatDao.removeChatListener()
                realmChat.saveRemoteChats()
                
            }
        }
    }
    
    func changeUserImage(){
        
        if UserManager.userManager.userImage != nil{
            userImage = UserManager.userManager.userImage
        }
        
    }
    
    // creates an async process that changes the user profile image as soon as it's avalable
    func imageChangeQueue(onComplete: @escaping () -> Void){
        
        let queue = DispatchQueue(label: "myQueue")
        queue.async {
            
            while UserManager.userManager.userImage == nil{
                continue
            }
            
            onComplete()
        }
    }
    
}
