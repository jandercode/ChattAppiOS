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
    
    
    var body: some View{
        
        NavigationView {
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
                            ProfilePic(size: 30, image: userImage!)
                        }.padding()
                    }
                    List{
                        
                        ForEach(firestoreChatDao.chats) { chat in
                            
                            ChatRow(chat: chat, chatName: firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), profilePic: getProfilePic(chat: chat) ,read: false)
                            
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    state.usersInChat = chat.users_in_chat
                                    state.chatId = chat.id
                                    state.chatName = chat.chat_name
                                    state.appState = .Message
                                    print(usersInChat)
                                }
                        }
                    }.refreshable {
                        print("refreshing")
                    }
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    NavigationLink(destination: NewChatView(state: state), isActive: $showNewChatView) {
                        EmptyView()
                    }.isDetailLink(false)
                    
                }.onAppear{
                    print("currentUser: \(String(describing: userManager.currentUser))")
                    
                    
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
                            showNewChatView = true
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
            }
        }.onAppear{
            
            if Reachability.isConnectedToNetwork(){
                isConnected = true
                print("Internet Connection Available!")
            } else {
                isConnected = false
                print("Internet Connection Not Available!")
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
            storage.loadChatProfilePics()
            
            //Realm
            realmChat.loadChats()
            realmMessage.loadMessages()
            
        }
        .onDisappear{
            
            firestoreChatDao.removeChatListener()
            
        }
    }
    
    func getProfilePic(chat: Chat) -> UIImage{
        
        let userId = chat.users_in_chat[1]
        return userManager.imageArray[userId] ?? UIImage(systemName: "person.circle")!
        
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
