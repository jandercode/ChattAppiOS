//
//  ChatsView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-07.
//

import SwiftUI

struct ChatsView: View{
    
    @ObservedObject var firestoreChatDao = FirestoreChatDao.firestoreChatDao
    @Binding var showNewChatView: Bool
    @State private var showChatView = false
    @State var usersInChat = [String]()
    @State var chatId = ""
    @State var chatName = ""
    @State var chatNameMinusCurrent = ""
    @State var presentUserInfo = false
    @State var userImage = UIImage(systemName: "person.circle")
    let storage = StorageManager()
    
    
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
                            ProfilePic(size: 32, image: userImage!)
                        }.padding()
                    }
                    
                    List{
                        ForEach(firestoreChatDao.chats) { chat in
                            ChatRow(chat: chat, chatName: firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), read: false, lastMessage: FirestoreMessageDao.firestoreMessageDao.lastMessage)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    usersInChat = chat.users_in_chat
                                    chatId = chat.id
                                    chatName = chat.chat_name
                                    print(usersInChat)
                                    showChatView = true
                                }
                        }
                    }.listStyle(.plain)
                    Spacer()
                    NavigationLink(destination: NewChatView(), isActive: $showNewChatView) {
                        EmptyView()
                    }.isDetailLink(false)
                    NavigationLink(destination: MessagesView(chatId: chatId, usersInChat: usersInChat, chatName: firestoreChatDao.removeCurrentFromChatName(chatName: chatName)), isActive: $showChatView) {
                        EmptyView()
                    }.isDetailLink(false)
                }.onAppear{
                   // chatNameMinusCurrent = firestoreChatDao.removeCurrentFromChatName(chatName: chatName)
                    if Reachability.isConnectedToNetwork(){
                        print("Internet Connection Available!")
                    } else {
                        print("Internet Connection Not Available!")
                    }
                    imageChangeQueue {
                        changeUserImage()
                    }
                    firestoreChatDao.listenToFirestore()
                    FirestoreContactDao.firestoreContactDao.removeCurrentUser()
                    
                }
                .sheet(isPresented: $presentUserInfo, content: {
                    UserInfoView(storage: storage)
                })
                .onDisappear {
                    
                    changeUserImage()
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
            
            storage.loadImageFromStorage(id: UserManager.userManager.currentUser!.id)
            storage.loadChatProfilePics()

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
