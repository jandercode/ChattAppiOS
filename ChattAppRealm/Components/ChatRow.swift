//
//  ChatRow.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-05.
//
import SwiftUI

struct ChatRow: View {
    var chat: Chat
    var chatName: String
    var profilePic: UIImage
   // var currentUserName = UserManager.userManager.currentUser?.username
   // var time: String
    var read: Bool
   // @State var lastMessage = Message()
  //  @State var lastMessage = Message()
    @ObservedObject var firestoreMessageDao = FirestoreMessageDao.firestoreMessageDao
    
    var body: some View {
        HStack {
            ZStack {
                Image(uiImage: profilePic)
                    .resizable()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading) {
                Text(chatName)
               // Text("last message...")
                Text(chat.lastMessage)
              //  Text(firestoreMessageDao.lastMessage?.text ?? "default last message")
                    .font(.system(size: 15))
            }
            
            Spacer()
           // Text(time)
           // Image(systemName: read ? "circle" : "circle.fill")
        }
        .padding(3)
        .onAppear{
            FirestoreMessageDao.firestoreMessageDao.listenToFirestore(chatId: chat.id)
           // lastMessage = FirestoreMessageDao.firestoreMessageDao.messages.last ?? Message()
           // FirestoreMessageDao.firestoreMessageDao.readLastMessage(chatId: chat.id) { message in
            //    self.lastMessage = message
           // }
           // lastMessage = FirestoreMessageDao.firestoreMessageDao.lastMessage
          //  print("lastMessage in ChatRow: \(lastMessage)")
        }
    }
    
}

//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow(chat: "Betty Sanders", time: "timestamp", read: false)
//    }
//}
