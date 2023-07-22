//
//  CreateVerbTemplate.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/3/23.
//

import SwiftUI

struct CreateVerbTemplate: View {
    
    @State var verbNameItalian: String = ""
    @State var verbNameEnglish: String = ""
    
    @State var presente: [String] = ["", "", "", "", "", ""]
    @State var passatoProssimo: [String] = ["", "", "", "", "", ""]
    @State var imperfetto: [String] = ["", "", "", "", "", ""]
    @State var futuro: [String] = ["", "", "", "", "", ""]
    @State var condizionale: [String] = ["", "", "", "", "", ""]
    @State var imperativo: [String] = ["", "", "", "", "", ""]
    
    @State var showingSheet: Bool = false
    
    @State var tenseForSheet: Int = 0
    
    @State var saveSuccess: Bool = false
    @State var showMessage: Bool = false
    
    @State var animateInvalidEntry: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
    
        ZStack{
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                    .tint(Color.black)
                
            }).padding(.bottom, 700).padding(.trailing, 300)
            
            VStack{
                HStack{
                    Text("Verb in Italian: ").padding(.trailing, 20)
                    TextField("", text: $verbNameItalian)
                        .font(.title)
                        .frame(width: 200)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }.padding(.bottom, 15)
                HStack{
                    Text("Verb in English: ").padding(.trailing, 11)
                    TextField("", text: $verbNameEnglish)
                        .font(.title)
                        .frame(width: 200)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }.padding(.bottom, 60)
                
                VStack{
                    HStack{
                        VStack{
                            Button(action: {
                                tenseForSheet = 0
                                showingSheet.toggle()
                                
                            },
                                   label: {
                                Text("Presente")
                                    .modifier(buttonModifier())
                                
                            })
                            
                            Button(action: {
                                tenseForSheet = 1
                                showingSheet.toggle()
                            }, label: {
                                Text("Passato Prossimo")
                                    .modifier(buttonModifier())
                                
                            })
                            
                            Button(action: {
                                tenseForSheet = 2
                                showingSheet.toggle()
                            }, label: {
                                Text("Imperfetto")
                                    .modifier(buttonModifier())
                                
                            })
                            
                        }
                        Spacer()
                        VStack{
                            Button(action: {
                                tenseForSheet = 3
                                showingSheet.toggle()
                            }, label: {
                                Text("Futuro")
                                    .modifier(buttonModifier())
                                
                            })
                            Button(action: {
                                tenseForSheet = 4
                                showingSheet.toggle()
                            }, label: {
                                Text("Condizionale")
                                    .modifier(buttonModifier())
                                
                            })
                            Button(action: {
                                tenseForSheet = 5
                                showingSheet.toggle()
                            }, label: {
                                Text("Imperativo")
                                    .modifier(buttonModifier())
                                
                            })
                            
                        }
                    }
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            
                            
                            if !finalSaveCheck() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    showMessage = false
                                }
                                saveSuccess = false
                                showMessage = true
                                SoundManager.instance.playSound(sound: .wrong)
                                animateView()
                            }else{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    showMessage = false
                                    dismiss()
                                }
                                saveSuccess = true
                                showMessage = true
                            
                                addVerbItem(nI: verbNameItalian, nE: verbNameEnglish, pres: presente, pass: passatoProssimo, fut: futuro, imp: imperfetto, imperat: imperativo, cond: condizionale)
                                
                                
                            }
                            
                        }, label: {
                            Text("Save")
                                .font(Font.custom("Arial Hebrew", size: 20)).padding(.top, 4)
                                .foregroundColor(.black)
                                .frame(width: 100, height: 35)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                            
                        })
                        Spacer()
                        
                        
                    }.padding(.top, 50)
                    
                    if saveSuccess {
                        Text("Saved to Available Verb List!")
                            .font(.title)
                            .padding(.top, 50)
                            .opacity(showMessage ? 1.0 : 0.0)
                    }else{
                        Text("Please fully fill out the verb information including the conjugation tables for each tense")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .padding(.top, 50)
                            .opacity(showMessage ? 1.0 : 0.0)
                    }
                    
                }.padding([.leading, .trailing], 15)
            }
            .sheet(isPresented: $showingSheet) {
                SheetViewVerbTemplate(tense: tenseForSheet, verbNameItalian: $verbNameItalian, verbNameEnglish: $verbNameEnglish, presente: $presente, passatoProssimo: $passatoProssimo, imperfetto: $imperfetto, futuro: $futuro, condizionale: $condizionale, imperativo: $imperativo)
            }
        }.offset(x: animateInvalidEntry ? -30 : 0)

    }
    
    func finalSaveCheck()->Bool{
        if verbNameItalian == "" || verbNameEnglish == "" {return false}
        if presente.isEmpty || presente.contains("") {return false}
        if passatoProssimo.isEmpty || passatoProssimo.contains("") {return false}
        if imperfetto.isEmpty || imperfetto.contains("") {return false}
        if futuro.isEmpty || futuro.contains("") {return false}
        if condizionale.isEmpty || condizionale.contains("") {return false}
        if imperativo.isEmpty || imperativo.contains("") {return false}else{return true}
    }
    
    func animateView(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateInvalidEntry = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateInvalidEntry  = false
            }
        }
    }
    
    func addVerbItem(nI: String, nE: String, pres: [String], pass: [String], fut: [String], imp: [String], imperat: [String], cond: [String] ) {
        withAnimation {
            let newUserMadeVerb = UserAddedVerb(context: viewContext)
            newUserMadeVerb.verbNameItalian = nI
            newUserMadeVerb.verbNameEnglish = nE
            newUserMadeVerb.presente = pres
            newUserMadeVerb.passatoProssimo = pass
            newUserMadeVerb.futuro = fut
            newUserMadeVerb.imperfetto = imp
            newUserMadeVerb.imperativo = imperat
            newUserMadeVerb.condizionale = cond
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    

}

struct SheetViewVerbTemplate: View {
    @Environment(\.dismiss) var dismiss
    
    var tense: Int
    
    @Binding var verbNameItalian: String
    @Binding var verbNameEnglish: String
    
    
    @State var io: String = ""
    @State var tu: String = ""
    @State var lui: String = ""
    @State var loro: String = ""
    @State var noi: String = ""
    @State var voi: String = ""
    
    @State var showingTenseArray: [String] = ["", "", "", "", "", ""]
    
    @Binding var presente: [String]
    @Binding var passatoProssimo: [String]
    @Binding var imperfetto: [String]
    @Binding var futuro: [String]
    @Binding var condizionale: [String]
    @Binding var imperativo: [String]
    
    @State var saveSuccess2: Bool = false
    @State var showMessage2: Bool = false
    
    
    @State var animateInvalidEntry2: Bool = false
    
    var body: some View{
        ZStack(alignment: .topLeading){
            
            Color.black.opacity(0.75).ignoresSafeArea()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                    .tint(Color.white)
                
            }).padding()
            
            VStack{
                
                Text(getTenseString(tenseInt: tense))
                    .font(.title)
                    .frame(width: 400, height: 50)
                    .foregroundColor(.black)
                    .background(.white.opacity(0.75))
                    .padding(.top, 100)
                
                
                Text(verbNameItalian + "\n" + verbNameEnglish)
                    .font(.title)
                    .frame(width: 200, height: 70)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.top, 40)
                
                VStack{
                    VStack{
                        HStack{
                            VStack{
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 0) ? "Io" : "", text: $io)
                                        .font(.title)
                                        .frame(width: 170)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                }.padding(.leading,15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 1) ? "Tu" : "", text: $tu)
                                        .font(.title)
                                        .frame(width: 170)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                }.padding(.leading,15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 2) ? "Lui/Lei/Lei" : "", text: $lui)
                                        .font(.title)
                                        .frame(width: 170)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                }.padding(.leading,15)
                                
                            }
                            Spacer()
                            VStack{
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 3) ? "Loro" : "", text: $loro)
                                        .font(.title)
                                        .frame(width: 170)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                }.padding(.trailing, 15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 4) ? "Noi" : "", text: $noi)
                                        .font(.title)
                                        .frame(width: 170)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                }.padding(.trailing, 15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 5) ? "Voi" : "", text: $voi)
                                        .font(.title)
                                        .frame(width: 170)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                }.padding(.trailing, 15)
                                
                            }
                        }
                    }.padding(.top, 40).padding([.leading, .trailing], 5)
                    
                }
            }
            
        }
        .offset(x: animateInvalidEntry2 ? -30 : 0)
        .onAppear{
            setShowingTenseArray(tenseIn: tense)
        }
        .onDisappear{
            setArray(tenseIn: tense)
        }
        
    }
    
    func setArray(tenseIn: Int){
        let conjArray = [io, tu, lui, loro, noi, voi]
        
        switch tenseIn{
        case 0:
            presente = conjArray
        case 1:
            passatoProssimo = conjArray
        case 2:
            imperfetto = conjArray
        case 3:
            futuro = conjArray
        case 4:
            condizionale = conjArray
        case 5:
            imperativo = conjArray
        default:
            presente = conjArray
        }
        
    }
    
    func setShowingTenseArray(tenseIn: Int){
        switch tenseIn{
        case 0:
            if !presente.isEmpty {
                io = presente[0]
                tu = presente[1]
                lui = presente[2]
                loro = presente[3]
                noi = presente[4]
                voi = presente[5]
            }
        case 1:
            if !passatoProssimo.isEmpty {
                io = passatoProssimo[0]
                tu = passatoProssimo[1]
                lui = passatoProssimo[2]
                loro = passatoProssimo[3]
                noi = passatoProssimo[4]
                voi = passatoProssimo[5]
            }
        case 2:
            if !imperfetto.isEmpty {
                io = imperfetto[0]
                tu = imperfetto[1]
                lui = imperfetto[2]
                loro = imperfetto[3]
                noi = imperfetto[4]
                voi = imperfetto[5]
            }
        case 3:
            if !futuro.isEmpty{
                io = futuro[0]
                tu = futuro[1]
                lui = futuro[2]
                loro = futuro[3]
                noi = futuro[4]
                voi = futuro[5]
            }
        case 4:
            if !condizionale.isEmpty{
                io = condizionale[0]
                tu = condizionale[1]
                lui = condizionale[2]
                loro = condizionale[3]
                noi = condizionale[4]
                voi = condizionale[5]
            }
        case 5:
            if !imperativo.isEmpty {
                io = imperativo[0]
                tu = imperativo[1]
                lui = imperativo[2]
                loro = imperativo[3]
                noi = imperativo[4]
                voi = imperativo[5]
            }
        default:
            io = presente[0]
            tu = presente[1]
            lui = presente[2]
            loro = presente[3]
            noi = presente[4]
            voi = presente[5]
        }
    }
    
    func checkIfConjBoxEmpty(indexIn: Int)->Bool{
        switch indexIn{
        case 0:
            if io == "" {
                return true
            }else {
                return false
            }
        case 1:
            if tu == "" {
                return true
            }else {
                return false
            }
        case 2:
            if lui == "" {
                return true
            }else {
                return false
            }
        case 3:
            if loro == "" {
                return true
            }else {
                return false
            }
        case 4:
            if noi == "" {
                return true
            }else {
                return false
            }
        case 5:
            if voi == "" {
                return true
            }else {
                return false
            }
        default:
            return true
        }
    }
    
    func getTenseString(tenseInt: Int)->String{
        switch tenseInt {
        case 0:
            return "Presente"
        case 1:
            return "PassatoProssimo"
        case 2:
            return "Imperfetto"
        case 3:
            return "Futuro"
        case 4:
            return "Condizionale"
        case 5:
            return "Imperativo"
        default:
            return ""
        }
    }
    
    func setConjArray(tense: Int, conjArray: [String]){
        switch tense {
        case 0:
            presente = conjArray
        case 1:
            passatoProssimo = conjArray
        case 2:
            imperfetto = conjArray
        case 3:
            futuro = conjArray
        case 4:
            condizionale = conjArray
        case 5:
            imperativo = conjArray
        default:
            showMessage2.toggle()
        }
    }
    
    func animateView2(){
        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
            animateInvalidEntry2 = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.2, blendDuration: 0.2)){
                animateInvalidEntry2  = false
            }
        }
    }
    

}
    

struct buttonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Arial Hebrew", size: 18)).padding(.top, 4)
            .foregroundColor(.white)
            .frame(width: 170, height: 40)
            .background(.teal)
            .cornerRadius(20)
    }
}

struct CreateVerbTemplate_Previews: PreviewProvider {
    static var previews: some View {
        CreateVerbTemplate()
    }
}
