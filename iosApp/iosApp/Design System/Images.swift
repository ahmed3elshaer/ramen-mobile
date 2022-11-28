//
//  Images.swift
//  BricksUI
//
//  Copyright © 2020 by a cool group. All rights reserved.
//

import SwiftUI

extension Image {
    
    //MARK: Avatars
    
    ///Turn image into a circular avatar
    func avatarCircle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            .padding(.all, 16)
        
    }
    
    ///Turn image into a rectangular avatar
    func avatarSquare() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(Rectangle())
            .padding(.all, 16)
        
    }
    ///Turn image into a rounded rectangle avatar
    func avatarRounded() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(.all, 16)
        
    }
    
    //MARK: Styled Images
    
    ///Modify image to fit a circular format
    func circle(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(Circle())
    }
    
    ///Modify image to fit a square format
    func square(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
    }
    
    ///Modify image to fit a rounded corners square format
    func rounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedRectangle(cornerRadius: width/10.0))
    }
    ///Modify image to have upper rounded corners in a square format
    func topRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.topLeft, .topRight]))
    }
    
    ///Modify image to have lower rounded corners in a square format
    func bottomRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .bottomRight]))
    }
    
    ///Modify image to have left-side rounded corners in a square format
    func leftRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomLeft, .topLeft]))
        
            
    }
    
    ///Modify image to have right-side rounded corners in a square format
    func rightRounded(width: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: width)
            .clipShape(RoundedCorner(radius: width/10.0, corners: [.bottomRight, .topRight]))
    }
    
    
}


struct Images_Previews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                Image("bricks_logo")
                    .avatarCircle()
                Image("bricks_logo")
                    .avatarSquare()
                Image("bricks_logo")
                    .avatarRounded()
                
            }.padding()
            
            HStack(spacing: 20) {
                Image("bricks_logo")
                    .circle(width: 90)
                Image("bricks_logo")
                    .square(width: 90)
                Image("bricks_logo")
                    .rounded(width: 90)
            }.padding()
            
            HStack(spacing: 20) {
                Image("bricks_logo")
                    .topRounded(width: 120)
                Image("bricks_logo")
                    .bottomRounded(width: 120)
            }.padding()
            
            HStack(spacing: 20) {
                Image("bricks_logo")
                    .leftRounded(width: 120)
                Image("bricks_logo")
                    .rightRounded(width: 120)
            }.padding()
        }
    }
}
