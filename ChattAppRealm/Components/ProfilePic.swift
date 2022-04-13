//
//  ProfilePic.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-13.
//

import SwiftUI

struct ProfilePic: View {
    var size: CGFloat
    var body: some View {
        Image("profile-pic")
            .resizable()
            .frame(width: size, height: size, alignment: .center)
            .cornerRadius(20)
    }
}

struct ProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePic(size: 40)
    }
}
