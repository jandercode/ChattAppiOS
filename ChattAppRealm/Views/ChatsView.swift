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
                .sheet(isPresented: $presentUserInfo, content: {
                    
                    UserInfoView()
                    
                })
            }
        }
    }
}
