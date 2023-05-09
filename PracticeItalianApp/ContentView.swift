//
//  ContentView.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 3/27/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView{
            GeometryReader{ geo in
                ZStack{
                    Image("homeWallpaper")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                        .opacity(1.0)
                    VStack{
                        Text("Italian\nPractice")
                            .bold()
                            .foregroundColor(Color.black)
                            .font(Font.custom("Zapfino", size: 36))
                            .multilineTextAlignment(.center)
                            .frame(width: 325, height: 250)
                            .background(Color.blue.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding(.bottom, 100)
                            .padding(.top, 100)
                        
                        
                        NavigationLink(destination: chooseActivity(), label: {Text ("Lets Practice!")
                                .bold()
                                .frame(width: 280, height: 50)
                                .background(Color.teal)
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                    
                        })
                    }.position(x:200, y:200)
                }
            }
        }
    }
    
    struct chooseActivity: View {
        var body: some View{
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
                        }).position(x:100, y:-120)
                    }
                }
            }
        }
    }
    
    
    struct chooseTense: View{
        var body: some View{
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
    
    struct chooseVCActivity: View{
        var tense: Int
        var body: some View{
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
                        NavigationLink(destination: spellConjVerbView(tense:tense), label: {Text ("Spell it out")
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
    
    struct BlueButton: ButtonStyle {
        
        @State var pressed = false
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(width:220, height: 50)
                .bold()
                .background(Color.teal)
                .foregroundColor(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.top, 15)
                .scaleEffect(pressed ? 1.25 : 1.0)
                .onLongPressGesture(minimumDuration: 2.5, maximumDistance: .infinity, pressing: { pressing in
                    withAnimation(.linear(duration: 1.0)) {
                        self.pressed = pressing
                    }
                    if pressing {

                        
                    } else {
                        
                    }
                }, perform: { })
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
