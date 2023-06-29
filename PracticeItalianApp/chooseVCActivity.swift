//
//  chooseVCActivity.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/12/23.
//

import SwiftUI

struct chooseVCActivity: View {
    
    var tense: Int
    
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
                    NavigationLink(destination: verbConjMultipleChoiceView(tenseIn: tense), label:{Text ("Multiple Choice")
                            .bold()
                            .frame(width: 150, height: 50)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                            .position(x:100, y:175)
                    })
                    NavigationLink(destination: SpellConjugatedVerbView(tense: tense), label: {Text ("Spell it out")
                            .bold()
                            .frame(width: 150, height: 50)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }).navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

struct chooseVCActivity_Previews: PreviewProvider {
    static var previews: some View {
        chooseVCActivity(tense: 0)
   
    }
}
