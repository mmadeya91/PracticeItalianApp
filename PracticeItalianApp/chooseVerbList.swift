//
//  chooseVerbList.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/5/23.
//

import SwiftUI

struct chooseVerbList: View {
    var body: some View {
        ZStack{
            VStack{
                NavigationLink(destination: chooseVCActivity(), label: {Image("reading-book")
                        .imageIconModifier()
                })
                Text("20 Most Used Italian Verbs")
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 18))
                    .frame(width: 120, height: 50)
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: ChooseVCActivityMyList(), label: {Image("reading-book")
                        .imageIconModifier()
                })
                Text("My List")
                    .bold()
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .frame(width: 120, height: 50)
            }
        }
    }
}

struct chooseVerbList_Previews: PreviewProvider {
    static var previews: some View {
        chooseVerbList()
    }
}
