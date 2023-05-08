//
//  shortStoryView.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 5/5/23.
//

import SwiftUI

extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}

struct shortStoryView: View {
    
    var chosenStoryName: String = "Cristofo Columbo"
    
    @State var showPopUpScreen: Bool = false
    @State var showQuestionDropdown: Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image("homeWallpaper")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .opacity(1.0)
                HStack{
                   
                        
                        Button(action: {
                        }, label: {
                            Image(systemName: "x.circle")
                                .foregroundColor(Color.black)
                                .font(.system(size:35, weight: .medium))
                                .padding(.leading, 10)

                        })
                      
                        Spacer()
                    
                 
                        Text(chosenStoryName)
                            .font(Font.custom("Arial Hebrew", size: 30))
                            .padding(.trailing, 55)
                            .offset(y:5)
 
                        Spacer()
                    

                }.frame(width: UIScreen.main.bounds.width, height: 50).background(Color.teal.opacity(0.3))
                    .offset(y: -330)
                
                testStory(showPopUpScreen: self.$showPopUpScreen).frame(width: 350, height:400).background(Color.white.opacity(1.0)).cornerRadius(20).overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 6))
                    .shadow(radius: 10)
                    .offset(x: -1, y:-90)
                
                if showPopUpScreen{
                    popUpView(showPopUpScreen: self.$showPopUpScreen).transition(.slide).animation(.easeIn)
                }
                
                questionsDropDownBar(showQuestionDropdown: self.$showQuestionDropdown).padding([.leading, .trailing], 5).offset(y:150)
                
                if showQuestionDropdown{
                    questionsView().padding([.leading, .trailing], 5).offset(y:274).transition(.move(edge: .bottom)).animation(.spring())
                }

            }
        }
    }
    
    
    
    
    
    
    struct testStory: View{
        
        @Binding var showPopUpScreen: Bool
        
        var body: some View{
            
            ScrollView(.vertical, showsIndicators: false) {
                    
                    Text("Cristoforo Colombo [nasce](myappurl://action?word=nasce) nel 1451 vicino a Genova, nel nord Italia. A 14 anni [diventa](myappurl://action?word=diventa) marinaio e viaggia in numerosi Paesi. Per Cristoforo Colombo la Terra è rotonda e verso la fine del ‘400, vuole viaggiare verso l’India e vuole farlo con un viaggio verso [ovest](myappurl://action?word=ovest). La [spedizione](myappurl://action?word=spedizione) è costosa e Colombo prima chiede aiuto al re del Portogallo e poi alla regina Isabella di Castiglia. Nel 1492, dopo mesi di navigazione, [scopre](myappurl://action?word=scopre) però un nuovo continente: l’America, che viene chiamata il Nuovo Mondo. Cristoforo Colombo fa altri viaggi in America ma ormai non è più così amato e così [muore](myappurl://action?word=muore) nel 1506 [povero e dimenticato](myappurl://action?word=dimenticato) da tutti.")
                        .modifier(textModifer())
                        .environment(\.openURL, OpenURLAction { url in
                            handleURL(url)
                        })
                }
            }
        
        
        func handleURL(_ url: URL) -> OpenURLAction.Result {
            showPopUpScreen.toggle()
            return .handled
        }
        
        
    }
    
    struct popUpView: View{
        
        @Binding var showPopUpScreen: Bool
        
        var body: some View{
            ZStack{
                
                Button(action: {
                    showPopUpScreen.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                        .font(.largeTitle)
                        .padding(20)
                }).position(x:40, y:30)
                
                Text("Nascire - To be Born")
                    .font(Font.custom("Arial Hebrew", size: 20))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                
            
            }.frame(width: 300, height: 200)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .offset(y:-90)
   
        }
    }
    
    struct questionsDropDownBar: View{
        
        @Binding var showQuestionDropdown: Bool
        
        var body: some View{
            
            ZStack{
                HStack{
                    
                    Text("Questions     " + "1/4")
                        .font(Font.custom("Arial Hebrew", size: 20))
                        .padding(.leading, 10)
                        .padding(.top, 5)

                    
                    Button(action: {
                        showQuestionDropdown.toggle()
                    }, label: {
                        Image(systemName: "chevron.down.square.fill")
                            .scaleEffect(2.8)
                    }).offset(x: 170)
                    
                    

                    
                }.frame(width: 360, height: 40, alignment: .leading)
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 3)
                        .stroke(.gray, lineWidth: 3).padding(.trailing, 40))
    
            }
            
        }
    }
    
    struct questionsView: View {
        
        
        var body: some View {
            ZStack{
                VStack(alignment: .leading){
                    Text("Where was Cristoro Columbo born?")
                        .font(Font.custom("Arial Hebrew", size: 18))
                        .padding([.leading, .top], 20)

                    
                    radioButtons()
                }.frame(width: 360, height: 200)
                    .background(Color.white).cornerRadius(3)
                    .zIndex(1)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(1))
                        .frame(width: 368, height: 200).padding(.top, 10)
                        .zIndex(0)
                        
                
            }
        }
    }
    
    struct radioButtons: View{
        var body: some View{
            VStack{
                
                Button(action: {}, label: {
                    
                    HStack{
                        Text("test1")
                        
                        Spacer()
                        
                        Circle().fill(Color.gray.opacity(0.25)).scaleEffect(0.5)
                    }.padding([.leading, .trailing], 20)
                })
                
                Button(action: {}, label: {
                    
                    HStack{
                        Text("test2")
                        
                        Spacer()
                        
                        Circle().fill(Color.gray.opacity(0.25)).scaleEffect(0.5)
                    }.padding([.leading, .trailing], 20)
                }).offset(y: -15)
                
                Button(action: {}, label: {
                    
                    HStack{
                        Text("test3")
                        
                        Spacer()
                        
                        Circle().fill(Color.gray.opacity(0.25)).scaleEffect(0.5)
                    }.padding([.leading, .trailing], 20)
                }).offset(y: -30)
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {}, label: {
                        Image(systemName: "chevron.backward.to.line")
                            .scaleEffect(1.75)
                        
                    }).padding(.trailing, 25)
                    
                    
                    Button(action: {}, label: {
                        Image(systemName: "chevron.forward.to.line")
                            .scaleEffect(1.75)
                        
                    }).padding(.leading, 25)
                    
                    Spacer()
                    
                }.offset(y:-18)
            }
        }
    }
    
    
    
    struct textModifer : ViewModifier {
        func body(content: Content) -> some View {
            content
                .font(Font.custom("Arial Hebrew", size: 18))
                .padding(.top, 40)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(20)
            
        }
    }
    
    
    struct shortStoryView_Previews: PreviewProvider {
        static var previews: some View {
            shortStoryView()
        }
    }
}

