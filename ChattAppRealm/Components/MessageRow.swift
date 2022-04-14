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
                ProfilePic(size: 40, image: UIImage(imageLiteralResourceName: "profile-pic"))
            } else {
                Spacer()
                ProfilePic(size: 40, image: UserManager.userManager.userImage!)
            }
            Text(message.text)
                .padding(10)
                .foregroundColor(message.sender == UserManager.userManager.currentUser?.id ? Color.black : Color.white)
                .background(message.sender == UserManager.userManager.currentUser?.id ? Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)) : Color.blue)
                .cornerRadius(10)
            if message.sender != UserManager.userManager.currentUser?.id {
                Spacer()
            }
        }.padding(.horizontal)
    }
}

//struct MessageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageRow()
//    }
//}
