//
//  ChatsView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-07.
//

import SwiftUI

struct ChatsView: View{
    
    @ObservedObject var firestoreChatDao = FirestoreChatDao.firestoreChatDao
    @ObservedObject var state: StateController
    
    @State var presentUserInfo = false
    @State var userImage = UIImage(systemName: "person.circle")
    @State var isConnected = false
    
    let storage = StorageManager()
    let realmUser = RealmUserDao()
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
                
                List(firestoreChatDao.chats){ chat in
                                            
                        ChatRow(chat: chat, chatName: firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), profilePic: storage.getProfilePics(usersInChatList: chat.users_in_chat))
                        
                            .listRowSeparator(.hidden)
                        
                            .onTapGesture {
                                
                                state.usersInChat = chat.users_in_chat
                                state.chatId = chat.id
                                state.chatName = chat.chat_name
                                state.appState = .Message
                            }
                    
                }
                .task{
                    
                    do{
                        try await storage.reload()
                    }catch{
                        let _ = error
                    }
                }
                
                .listStyle(.plain)
                
                Spacer()
                
            }.sheet(isPresented: $presentUserInfo){
                
                UserInfoView(storage: storage, state: state, userImage: $userImage)
                
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
                
            }
        }.onAppear{
            
            if Reachability.isConnectedToNetwork(){
                isConnected = true
            } else {
                isConnected = false
            }
            
            if ManageLoginInfo.loadLogin(){
                
                realmUser.saveUser(newUser: UserManager.userManager.currentUser!)
                ManageLoginInfo.saveLogin(saveInfo: true)
            }
            imageChangeQueue {
                changeUserImage()
            }
            
            //Firestore
            firestoreChatDao.listenToFirestore()
            FirestoreUserDao.firestoreContactDao.removeCurrentUser()
            
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
