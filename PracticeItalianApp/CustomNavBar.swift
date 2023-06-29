//
//  CustomNavBar.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/26/23.
//

import SwiftUI

struct CustomNavBar: View {
    
    
    var body: some View {
        ZStack{
            HStack{
                NavigationLink(destination: chooseActivity(), label: {Image("cross")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 10)
                })
                
                Spacer()
                
                Text("Learning Activities")
                    .bold()
                    .font(Font.custom("Marker Felt", size: 25))
                
                Spacer()
                
                NavigationLink(destination: chooseActivity(), label: {Image("house")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.5)
                        .padding([.top, .bottom], 15)
                        .padding(.trailing, 30)
                       
                })
            }.zIndex(1)
        }.frame(width: 400, height: 60)
            .background(Color.gray.opacity(0.25))
            .border(width: 3, edges: [.bottom, .top], color: .teal)

    }
}

struct CustomNavBar_Previews: PreviewProvider {

    static var previews: some View {
        CustomNavBar()
    }
}
