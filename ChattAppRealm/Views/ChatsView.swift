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
    
    var body: some View{
        
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    Text("Chats")
                    List{
                        ForEach(firestoreChatDao.chats) { chat in
                            Text(chat.id)
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
                }.onAppear{
                    
                    firestoreChatDao.listenToFirestore()
                    FirestoreContactDao.firestoreContactDao.getUsers()
                    
                }
            }
        }
    }
}
