//
//  MessagesView.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//

import SwiftUI
import Firebase

struct ChatView: View {
    let db = Firestore.firestore()
    @ObservedObject var firestoreContactDao = FirestoreMessageDao()
    
    @State private var messageText: String = ""
    
    var body: some View {
        VStack {
            List {
                Text("hello")
                Text("hey! how are you?")
                Text("pretty good thanks")
            }
            HStack {
                TextField("Aa", text: $messageText)
                Button {
                    // create a new chat in firestore if it doesn't already exist
                   // db.collection("tmp").addDocument(data: ["chatName" : "chat1"])
                    // add new message to firestore
                   // db.collection("tmp").addDocument(data: ["messageText": messageText])
                } label: {
                    Text("Send")
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
