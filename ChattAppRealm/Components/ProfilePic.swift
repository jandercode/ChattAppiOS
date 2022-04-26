//
//  ProfilePic.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-13.
//

import SwiftUI

struct ProfilePic: View {
    var size: CGFloat
    var images: [UIImage]
    var body: some View {
        
        if images.count <= 1 {
            Image(uiImage: images[0])
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .cornerRadius(size/2)
        } else if images.count == 2 {
            TwoProfilePic(images: images)
                .frame(width: size, height: size, alignment: .leading)
        } else if images.count > 2 {
            ThreeProfilePic(images: images)
                .frame(width: size, height: size, alignment: .center)
        }
    }
}


struct TwoProfilePic: View {
    var size: CGFloat = 30
    var images: [UIImage]
    var body: some View {
        ZStack {
            Image(uiImage: images[0])
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .cornerRadius(size/2)
            
            Image(uiImage: images[1])
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .cornerRadius(size/2)
                .offset(x: 15, y: 15)
        }
    }
}

struct ThreeProfilePic: View {
    var size: CGFloat = 30
    var images: [UIImage]
    var body: some View {
        ZStack {
            Image(uiImage: images[2])
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .cornerRadius(size/2)
                .offset(x: -10, y: 15)
            Image(uiImage: images[0])
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .cornerRadius(size/2)
            Image(uiImage: images[1])
                .resizable()
                .frame(width: size, height: size, alignment: .center)
                .cornerRadius(size/2)
                .offset(x: 10, y: 15)
            
        }
    }
}
