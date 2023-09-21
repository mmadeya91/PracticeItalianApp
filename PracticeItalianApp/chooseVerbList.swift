//
//  chooseVerbList.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/5/23.
//

import SwiftUI

struct chooseVerbList: View {

@ObservedObject var globalModel = GlobalModel()
@State private var animatingBear = false
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                
                HStack(spacing: 18){
               
                        NavigationLink(destination: chooseActivity(), label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                            
                        }).padding(.leading, 25).padding(.top, 15)
 
                
                    
                    Spacer()
                    VStack{
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .shadow(radius: 10)
                        HStack{
                            Image("coin2")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
     
                            
                            Text(String(globalModel.userCoins))
                                .font(Font.custom("Arial Hebrew", size: 22))
                        }.padding(.top,10).padding(.trailing, 45)
                    }.padding(.top, 85)
                }.zIndex(2).offset(y:-380)
                
                Image("sittingBear")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 100)
                    .offset(x: -45, y: animatingBear ? -260 : 0)
                
                VStack{
                    
                    ScrollView{
                        VStack{
                            Text("Verb Sets").zIndex(1)
                                .font(Font.custom("Marker Felt", size: 30))
                                .foregroundColor(.white)
                                .frame(width: 350, height: 60)
                                .background(Color("DarkNavy")).opacity(0.75)
                                .border(width: 8, edges: [.bottom], color: .teal)
                            HStack{
                                Spacer()
                                VStack{
                                    NavigationLink(destination: chooseVCActivity(), label: {Image("reading-book")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 65, height: 65)
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(60)
                                            .overlay( RoundedRectangle(cornerRadius: 60)
                                                .stroke(.black, lineWidth: 3))
                                            .shadow(radius: 10)
                                    })
                                    Text("20 Most Used Italian Verbs")
                                        .bold()
                                        .font(Font.custom("Arial Hebrew", size: 18))
                                        .frame(width: 120, height: 50)
                                        .multilineTextAlignment(.center)
                                }
                                Spacer()
                                VStack{
                                    NavigationLink(destination: ChooseVCActivityMyList(), label: {Image("reading-book")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 65, height: 65)
                                            .padding()
                                            .background(.white)
                                            .cornerRadius(60)
                                            .overlay( RoundedRectangle(cornerRadius: 60)
                                                .stroke(.black, lineWidth: 3))
                                            .shadow(radius: 10)
                                    })
                                    Text("My List")
                                        .bold()
                                        .font(Font.custom("Arial Hebrew", size: 20))
                                        .frame(width: 120, height: 50)
                                }
                                Spacer()
                            }.padding(.top, 25)
                        }
                    }.frame(width:345, height: 600).background(Color("WashedWhite")).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 4))
                    .padding(.top, 40)
                }
            }.onAppear{
                withAnimation(.spring()){
                    animatingBear = true
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct chooseVerbList_Previews: PreviewProvider {
    static var previews: some View {
        chooseVerbList().environmentObject(GlobalModel())
    }
}
