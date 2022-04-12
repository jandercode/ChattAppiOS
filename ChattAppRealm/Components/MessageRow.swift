//
//  MessageRow.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-12.
//

import SwiftUI

struct MessageRow: View {
    var message : Message
    
    var body: some View {
        HStack {
            if message.sender != UserManager.userManager.currentUser?.id {
                Image("profile-pic")
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
            } else {
                Spacer()
            }
            Text(message.text)
                .padding(10)
                .foregroundColor(message.sender == UserManager.userManager.currentUser?.id ? Color.black : Color.white)
                .background(message.sender == UserManager.userManager.currentUser?.id ? Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)) : Color.blue)
                .cornerRadius(10)
        }
    }
}

//struct MessageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageRow()
//    }
//}
