//
//  BackupView.swift
//  ChattAppRealm
//
//  Created by Luca Salmi on 2022-04-26.
//

import SwiftUI

struct BackupView: View {
    
    @ObservedObject var state: StateController
    
    @State var showChat = false
    @State var presentationArray = [Chat]()
    
    var body: some View {
        
            
            VStack{
                
                List{
                    
                    ForEach (presentationArray){ chat in
                        
                        
                        ChatRow(chat: chat, chatName: FirestoreChatDao.firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), profilePic: UIImage(systemName: "person.circle")! ,read: false)
                        
                            .onTapGesture {
                                
                                state.usersInChat = chat.users_in_chat
                                state.chatId = chat.id
                                state.chatName = chat.chat_name
                                state.messageRealm?.filterMessages(chatId: state.chatId)
                                state.appState = .BackupChat
                                
                            }
                    }
                }
                
                HStack{
                    
                    Button {
                        
                        state.appState = .Chats
                        
                    } label: {
                        
                        Image(systemName: "chevron.left")
                        Text("Exit")
                    }
                    .padding()
                    
                    
                    Button {
                        
                        state.chatRealm?.chatsArray.removeAll()
                        state.messageRealm?.allMessages.removeAll()
                        presentationArray.removeAll()
                        state.messageRealm?.deleteAllMessages()
                        state.chatRealm?.deleteAllChats()
                        state.appState = .Chats
                        
                    } label: {
                        Text("Erase All")
                            .foregroundColor(.red)
                    }
                    .padding()
                }
                
                
                
            }.onAppear{
                
                if state.chatRealm == nil{
                    state.chatRealm = RealmChatDao()
                    state.chatRealm?.loadChats()
                }
                if state.messageRealm == nil{
                    state.messageRealm = RealmMessageDao()
                    state.messageRealm?.loadMessages()
                }
                
                presentationArray = state.chatRealm!.chatsArray
            }
    }
}

