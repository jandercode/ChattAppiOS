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
    @State var presentUserInfo = false
    
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
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                        }.padding()


                        
                        
                    }
                    
                    List{
                        ForEach(firestoreChatDao.chats) { chat in
                            Text("\(chat.users_in_chat[0]), \(chat.users_in_chat[1])")
                        .onTapGesture {
                            usersInChat = chat.users_in_chat
                            chatId = chat.id
                            print(usersInChat)
                            showChatView = true
                        }
                    }
                    }
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
                    NavigationLink(destination: NewChatView(), isActive: $showNewChatView) {
                        EmptyView()
                    }.isDetailLink(false)
                    NavigationLink(destination: MessagesView(chatId: chatId, usersInChat: usersInChat), isActive: $showChatView) {
                        EmptyView()
                    }.isDetailLink(false)
                }.onAppear{
                    
                    firestoreChatDao.listenToFirestore()
                    FirestoreContactDao.firestoreContactDao.getUsers()
                    print("CHATSVIEW messages-innehåll: \(FirestoreMessageDao.firestoreMessageDao.messages)")
                }
                .sheet(isPresented: $presentUserInfo, content: {
                    
                    UserInfoView()
                    
                })
            }
        }
    }
}
