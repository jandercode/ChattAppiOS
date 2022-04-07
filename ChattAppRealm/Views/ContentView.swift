//
//  ContentView.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State private var showNewChatView = false
    let db = Firestore.firestore()
    @ObservedObject var firestoreContactDao = FirestoreContactDao()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                VStack {
                    Text("Chats")
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            firestoreContactDao.saveContact()
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
//                        .onTapGesture {
//                            self.showNewChatView = true
//                        }
                    }
                    NavigationLink(destination: NewChatView(), isActive: $showNewChatView) {
                        EmptyView()
                    }.isDetailLink(false)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
