//
//  chooseTense.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/12/23.
//

import SwiftUI

struct chooseTense: View {
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
                    HStack{
                        NavigationLink(destination: chooseVCActivity(tense: 0), label: {Text ("Presento")
                                .bold()
                                .frame(width: 150, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .position(x:100, y:220)
                            
                        })
                        NavigationLink(destination: chooseVCActivity(tense: 1), label: {Text ("Passato Prossimo")
                                .bold()
                                .frame(width: 150, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .position(x:100, y:220)
                        })
                    }
                    HStack{
                        NavigationLink(destination: chooseVCActivity(tense: 2), label: {Text ("Imperfetto")
                                .bold()
                                .frame(width: 150, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .position(x:100, y:50)
                        })
                        NavigationLink(destination: chooseVCActivity(tense: 3), label: {Text ("Futuro")
                                .bold()
                                .frame(width: 150, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .position(x:100, y:50)
                        })
                    }
                    HStack{
                        NavigationLink(destination: chooseVCActivity(tense: 4), label: {Text ("Conditionale")
                                .bold()
                                .frame(width: 150, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .position(x:100, y:-120)
                        })
                        NavigationLink(destination: chooseVCActivity(tense: 5), label: {Text ("Imperativo")
                                .bold()
                                .frame(width: 150, height: 50)
                                .background(Color.blue)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .position(x:100, y:-120)
                        })
                    }
                }
            }
        }
    }
}

struct chooseTense_Previews: PreviewProvider {
    static var previews: some View {
        chooseTense()
    }
}
