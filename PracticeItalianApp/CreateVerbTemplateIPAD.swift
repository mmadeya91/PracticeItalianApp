//
//  CreateVerbTemplateIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/10/24.
//

import SwiftUI

struct CreateVerbTemplateIPAD: View {
    
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
        GeometryReader {geo in
            Image("verticalNature")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            ZStack(alignment: .topLeading){
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                        .tint(Color.black)
                    
                }).padding(.leading, 15)
                
                VStack{
                    HStack{
                        Text("Verb in Italian: ").padding(.trailing, 20).font(.system(size: 25))
                        TextField("", text: $verbNameItalian)
                            .font(.system(size: 35))
                            .frame(width: 250)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }.padding(.bottom, 15)
                    HStack{
                        Text("Verb in English: ").padding(.trailing, 11).font(.system(size: 25))
                        TextField("", text: $verbNameEnglish)
                            .font(.system(size: 35))
                            .frame(width: 250)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }.padding(.bottom, 60)
                    
                    VStack{
                        HStack{
                            VStack(spacing: 12){
                                Button(action: {
                                    tenseForSheet = 0
                                    showingSheet.toggle()
                                    
                                },
                                       label: {
                                    Text("Presente")
                                        .modifier(buttonModifierIPAD())
                                    
                                })
                                
                                Button(action: {
                                    tenseForSheet = 1
                                    showingSheet.toggle()
                                }, label: {
                                    Text("Passato Prossimo")
                                        .modifier(buttonModifierIPAD())
                                    
                                })
                                
                                Button(action: {
                                    tenseForSheet = 2
                                    showingSheet.toggle()
                                }, label: {
                                    Text("Imperfetto")
                                        .modifier(buttonModifierIPAD())
                                    
                                })
                                
                            }.padding(.trailing, 55)
                       
                            VStack(spacing: 12){
                                Button(action: {
                                    tenseForSheet = 3
                                    showingSheet.toggle()
                                }, label: {
                                    Text("Futuro")
                                        .modifier(buttonModifierIPAD())
                                    
                                })
                                Button(action: {
                                    tenseForSheet = 4
                                    showingSheet.toggle()
                                }, label: {
                                    Text("Condizionale")
                                        .modifier(buttonModifierIPAD())
                                    
                                })
                                Button(action: {
                                    tenseForSheet = 5
                                    showingSheet.toggle()
                                }, label: {
                                    Text("Imperativo")
                                        .modifier(buttonModifierIPAD())
                                    
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
                                    .font(Font.custom("Arial Hebrew", size: 25)).padding(.top, 4)
                                    .foregroundColor(.black)
                                    .frame(width: 150, height: 45)
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
                }.padding(.top, 200)
                .sheet(isPresented: $showingSheet) {
                    SheetViewVerbTemplateIPAD(tense: tenseForSheet, verbNameItalian: $verbNameItalian, verbNameEnglish: $verbNameEnglish, presente: $presente, passatoProssimo: $passatoProssimo, imperfetto: $imperfetto, futuro: $futuro, condizionale: $condizionale, imperativo: $imperativo)
                }
            }.offset(x: animateInvalidEntry ? -30 : 0)
            
        }
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

struct SheetViewVerbTemplateIPAD: View {
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
            
            Color("DarkNavy").opacity(0.75).ignoresSafeArea()
            
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
                    .frame(width: 450, height: 50)
                    .foregroundColor(.black)
                 
                    .padding(.top, 100)
                    .offset(x: 120)
                
                
                
                Text(verbNameItalian + "\n" + verbNameEnglish)
                    .font(.title)
                    .frame(width: 350, height: 110)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .overlay( RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 2))
                    .padding(.top, 40)
                    .offset(x: 120)
                
                VStack{
                    VStack{
                        HStack{
                            VStack(spacing: 20){
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 0) ? "Io" : "", text: $io)
                                        .font(.system(size: 35))
                                        .padding(.leading, 10)
                                        .frame(width: 200)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2))
                                }.padding(.leading,15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 1) ? "Tu" : "", text: $tu)
                                        .font(.system(size: 35))
                                        .padding(.leading, 10)
                                        .frame(width: 200)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2))
                                }.padding(.leading,15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 2) ? "Lui/Lei/Lei" : "", text: $lui)
                                        .font(.system(size: 35))
                                        .padding(.leading, 10)
                                        .frame(width: 200)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2))
                                }.padding(.leading,15)
                                
                            }.padding(.trailing, 35)
                        
                            VStack(spacing: 20){
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 3) ? "Loro" : "", text: $loro)
                                        .font(.system(size: 35))
                                        .padding(.leading, 10)
                                        .frame(width: 200)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2))
                                }.padding(.trailing, 15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 4) ? "Noi" : "", text: $noi)
                                        .font(.system(size: 35))
                                        .padding(.leading, 10)
                                        .frame(width: 200)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2))
                                }.padding(.trailing, 15)
                                
                                HStack{
                                    TextField(checkIfConjBoxEmpty(indexIn: 5) ? "Voi" : "", text: $voi)
                                        .font(.system(size: 35))
                                        .padding(.leading, 10)
                                        .frame(width: 200)
                                        .background(.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 10)
                                        .overlay( RoundedRectangle(cornerRadius: 10)
                                        .stroke(.black, lineWidth: 2))
                                }.padding(.trailing, 15)
                                
                            }
                        }
                    }.padding(.top, 40).padding([.leading, .trailing], 5)
                        .offset(x: 120)
                    
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
    

struct buttonModifierIPAD: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Arial Hebrew", size: 23)).padding(.top, 4)
            .foregroundColor(.white)
            .frame(width: 250, height: 50)
            .background(.teal)
            .cornerRadius(20)
            .overlay( RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 2))
            .shadow(radius: 10)
            .padding([.top, .bottom], 5)
    }
}

struct CreateVerbTemplateIPAD_Previews: PreviewProvider {
    static var previews: some View {
        CreateVerbTemplateIPAD()
    }
}
