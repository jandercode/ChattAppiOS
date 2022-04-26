//
//  ShowUsernames.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-25.
//

import SwiftUI

struct ShowUsernamesSheet: View {
    
    @State private var showUsernames = false
    @State var chatName : String
    @State var profilePicArray : [UIImage]
    
    var body: some View {
        VStack {
            Text(chatName)
                .padding(20)
            ForEach(profilePicArray, id: \.self) { image in
                ProfilePic(size: 40, images: [image])
            }
        }
            .onAppear() {
                self.showUsernames = true
        }
            .onDisappear {
                
            }
    }
}

