//
//  chooseActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/13/23.
//

import SwiftUI

struct chooseActivity: View {
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("watercolor2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                VStack{
                    NavigationLink(destination: chooseTense(), label:{Text ("Verb Conjugation")
                            .bold()
                            .frame(width: 150, height: 50)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }).position(x:100, y:175)
                    NavigationLink(destination: availableShortStories(), label: {Text ("Reading")
                            .bold()
                            .frame(width: 150, height: 50)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    })
                }.navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct chooseActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseActivity()
    }
}
