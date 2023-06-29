//
//  shortStoryPlugInQuestions.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 6/2/23.
//

import SwiftUI

struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]
    
    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MyTextPreferenceData: Equatable {
    let viewIdx: Int
    let rect: CGRect
}

class offSetObject {
    var xCoord: CGFloat
    var yCoord: CGFloat
    
    init(xCoord: CGFloat, yCoord: CGFloat) {
        self.xCoord = xCoord
        self.yCoord = yCoord
    }
    
}

class offsetBlankSpace {
    var xCoord: CGFloat
    var yCoord: CGFloat
    
    init(xCoord: CGFloat, yCoord: CGFloat) {
        self.xCoord = xCoord
        self.yCoord = yCoord
    }
    
}

struct shortStoryPlugInQuestions: View {
    
    var shortStoryObjIn: shortStoryObject
    var storyNameIn: String
    
    @State private var activeIdx: Int = 0
    @State private var fontOpacity: CGFloat = 0.0
    @State private var rects: [CGRect] = Array<CGRect>(repeating: CGRect(), count: 12)
    @State private var toggled: Bool = false
    
    @State private var offSetArray: [offSetObject] = [offSetObject(xCoord: 45, yCoord: 635), offSetObject(xCoord: 190, yCoord: 470), offSetObject(xCoord: 60, yCoord: 490), offSetObject(xCoord: 95, yCoord: 560 ), offSetObject(xCoord: 235, yCoord: 570), offSetObject(xCoord: 180, yCoord: 660)]
    
    var body: some View {
            

        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                
                customTopNavBar3(chosenStoryNameIn: storyNameIn)
                
                correctButton(choiceString: shortStoryObjIn.plugInQuestionlist[activeIdx].missingWord, sSO: shortStoryObjIn, activeIdx: $activeIdx, fontOpacity: $fontOpacity, rects: $rects, toggled: $toggled, offsetArray: $offSetArray, offsetObj: offSetArray[0]).zIndex(1)


                    shortStoryPlugInChoiceButton(choiceString: shortStoryObjIn.plugInQuestionlist[activeIdx].choices[0]).offset(x:offSetArray[1].xCoord, y: offSetArray[1].yCoord)
                    shortStoryPlugInChoiceButton(choiceString: shortStoryObjIn.plugInQuestionlist[activeIdx].choices[1]).offset(x:offSetArray[2].xCoord, y: offSetArray[2].yCoord)
                    
                    shortStoryPlugInChoiceButton(choiceString: shortStoryObjIn.plugInQuestionlist[activeIdx].choices[2]).offset(x:offSetArray[3].xCoord, y: offSetArray[3].yCoord)
                    shortStoryPlugInChoiceButton(choiceString: shortStoryObjIn.plugInQuestionlist[activeIdx].choices[3]).offset(x:offSetArray[4].xCoord, y: offSetArray[4].yCoord)
                    shortStoryPlugInChoiceButton(choiceString: shortStoryObjIn.plugInQuestionlist[activeIdx].choices[4]).offset(x:offSetArray[5].xCoord, y: offSetArray[5].yCoord)
                    
        
                VStack {
                    
                    progressBarSSPlugInQuestions(counter: $activeIdx, totalCards: shortStoryObjIn.plugInQuestionlist.count).padding(.top, 80).padding(.trailing, 20)
                    
                    shortStoryScrollViewBuilder(sSO: shortStoryObjIn, fontOpacity: $fontOpacity, rects: $rects, activeIdx: $activeIdx, toggled: $toggled).padding(.top, 50)
                    
                    englishLine(englishLine: shortStoryObjIn.plugInQuestionlist[activeIdx].englishLine1)
                    
                    
                }.onPreferenceChange(MyTextPreferenceKey.self) { preferences in
                    for p in preferences {
                        self.rects[p.viewIdx] = p.rect
                    }
                }
            }.coordinateSpace(name: "myZstack")
        }.coordinateSpace(name: "myZstack")
    }
}



struct shortStoryScrollViewBuilder: View {
    
    var sSO: shortStoryObject
    
    @Binding var fontOpacity: CGFloat
    @Binding var rects: [CGRect]
    @Binding var activeIdx: Int
    @Binding var toggled: Bool
    
    var body: some View{
        ScrollViewReader {scrollView in
            ScrollView(.horizontal){
                HStack{
                    ForEach(0..<sSO.plugInQuestionlist.count, id: \.self) {i in
                        MonthView(fontOpacity: $fontOpacity, sSO: sSO, questionNumber: i, idx: i)
                            .padding([.leading, .trailing],18)

                    }
                }
                
            }.onChange(of: activeIdx) { newValue in
                scrollView.scrollTo(activeIdx)}.scrollDisabled(true)

        }
    }
}

struct MonthView: View {
    @Binding var fontOpacity: CGFloat
    var sSO: shortStoryObject
    var questionNumber: Int
    let idx: Int
    
    var body: some View {
        
        var blankSpaceOffset: [offsetBlankSpace] = [offsetBlankSpace(xCoord: 90, yCoord: -30)]
        
        ZStack{
            
            
            Text("f" + sSO.plugInQuestionlist[questionNumber].missingWord + "f")
                .font(Font.custom("Arial Hebrew", size: 21))
                .foregroundColor(.black.opacity(fontOpacity))
                .padding(.bottom, 2) // <- play with distance
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.black).frame(height: 2),
                    alignment: .bottom
                ).padding(.bottom, 8)
                .background(MyPreferenceViewSetter(idx: idx))
                .zIndex(1)
                .offset(x:90, y:-30)
                
            VStack{
                
                
                Text(sSO.plugInQuestionlist[questionNumber].questionPart1 + "   " + sSO.plugInQuestionlist[questionNumber].missingWord + "   " + sSO.plugInQuestionlist[questionNumber].questionPart2)
                    .font(Font.custom("Arial Hebrew", size: 21))
                    .padding([.leading, .trailing], 20)
                    .padding([.top, .bottom], 5)
                    .lineSpacing(8)
                    .multilineTextAlignment(.leading)
                
                
            }.frame(width: 325, height: 180)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding()
            
            
            
        }.background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.teal)
                .frame(width: 355, height: 200)
                .shadow(radius: 5)
        )

    }
    
    
}

struct englishLine: View {
    
    var englishLine: String
    
    var body: some View {
        
        Text(englishLine)
            .font(Font.custom("Arial Hebrew", size: 20))
            .underline()
        
    }
}


struct correctButton: View {
    
    var choiceString: String
    
    var sSO: shortStoryObject
    
    @State var defColor: Color = Color.white
    
    @Binding var activeIdx: Int
    @Binding var fontOpacity: CGFloat
    @Binding var rects: [CGRect]
    @Binding var toggled: Bool
    @Binding var offsetArray: [offSetObject]
    
    var offsetObj: offSetObject
    
    var body: some View {
        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                if activeIdx < sSO.plugInQuestionlist.count - 1 {
                    activeIdx = activeIdx + 1
                    toggled.toggle()
                    offsetArray.shuffle()
                    defColor = Color.white
                }
                
                

            }
            withAnimation(.easeInOut(duration: 1.5)) {
                toggled.toggle()
            }
            
            SoundManager.instance.playSound(sound: .correct)
            defColor = Color.green

        }, label: {
            Text(choiceString)
                .font(Font.custom("Arial Hebrew", size: 18))
                .padding(.top, 6)
                .padding([.leading, .trailing], 2)
            
        }).frame()
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 20)
            .foregroundColor(.black)
            .background(defColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .offset(x: toggled ? rects[activeIdx].minX-9 : offsetObj.xCoord, y: toggled ? rects[activeIdx].minY-5: offsetObj.yCoord)
    }
}

struct MyPreferenceViewSetter: View {
    let idx: Int
    
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.white)
                .preference(key: MyTextPreferenceKey.self,
                            value: [MyTextPreferenceData(viewIdx: self.idx, rect: geometry.frame(in: .named("myZstack")))])
        }
    }
}

struct shortStoryPlugInChoiceButton: View {
    var choiceString: String
    
    @State var defColor = Color.white
    @State private var pressed: Bool = false
    @State var selected = false
    var body: some View {
        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                defColor = Color.white
                }
            
            defColor = .red.opacity(0.5)
            
            withAnimation((Animation.default.repeatCount(5).speed(6))) {
                selected.toggle()
                
            }
            
            SoundManager.instance.playSound(sound: .wrong)
            selected.toggle()
            
        }, label: {
            Text(choiceString)
                .font(Font.custom("Arial Hebrew", size: 18))
                .padding(.top, 5)
                .padding([.leading, .trailing], 2)
            
        }).frame()
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 20)
             .background(defColor)
             .foregroundColor(.black)
             .cornerRadius(10)
             .shadow(radius: 5)
             .offset(x: selected ? -5 : 0)
  

    }
}

struct progressBarSSPlugInQuestions: View {
    
    @Binding var counter: Int
    let totalCards: Int
    
    var body: some View {
        VStack {
            
            Text(String(counter + 1) + "/" + String(totalCards)).offset(y:20)
                .font(Font.custom("Arial Hebrew", size: 28))
                .bold()
            
            ProgressView("", value: Double(counter), total: Double(totalCards - 1))
                .tint(Color.orange)
                .frame(width: 300)
                .scaleEffect(x: 1, y: 4)
                
            
            
        }
    }
}

struct customTopNavBarSSPlugIn: View {
    var body: some View {
        ZStack{
            HStack{
                NavigationLink(destination: availableShortStories(), label: {Image("cross")
                        .resizable()
                        .scaledToFit()
                        .padding(.leading, 20)
                })
                
                Spacer()
                
                NavigationLink(destination: chooseActivity(), label: {Image("house")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.5)
                        .padding([.top, .bottom], 15)
                        .padding(.trailing, 38)
                       
                })
            }.zIndex(1)
        }.frame(width: 400, height: 60)
            .background(Color.gray.opacity(0.25))
            .border(width: 3, edges: [.bottom, .top], color: .teal)
            .zIndex(0)
                    
    }
}


struct preview: View{
    var storyData2: shortStoryData { shortStoryData(chosenStoryName: "Cristofo Columbo")}
    
    var storyObj2: shortStoryObject {storyData2.collectShortStoryData(storyName: "Cristofo Columbo")}
    var body: some View{
        shortStoryPlugInQuestions(shortStoryObjIn: storyObj2, storyNameIn: "Cristofo Columbo")
    }
}


struct shortStoryPlugInQuestions_Previews: PreviewProvider {
    
    static var previews: some View {
 
        
        preview()
    }
}
