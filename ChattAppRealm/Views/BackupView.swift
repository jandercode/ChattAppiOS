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
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                List{
                    
                    ForEach (state.chatRealm!.chatsArray){ chat in
                        
                        ChatRow(chat: chat, chatName: FirestoreChatDao.firestoreChatDao.removeCurrentFromChatName(chatName: chat.chat_name), profilePic: UIImage(systemName: "person.circle")! ,read: false)
                        
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                
                                state.usersInChat = chat.users_in_chat
                                state.chatId = chat.id
                                state.chatName = chat.chat_name
                                showChat = true
                            }
                        
                        NavigationLink(isActive: $showChat) {
                            BackupChatView(state: state)
                        } label: {
                            Text("View Backup")
                        }
                        
                    }
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
            }
        }
        
    }
}

