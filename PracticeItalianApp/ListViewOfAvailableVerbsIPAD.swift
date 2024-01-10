//
//  ListViewOfAvailableVerbsIPAD.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 1/10/24.
//

import SwiftUI
import Algorithms


struct ListViewOfAvailableVerbsIPAD: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isEmpty: Bool = false
    
    @State var availableVerbs: [UserAddedVerb] = []
    
    @State var showCreateVerb: Bool = false
    @State var showingSheet: Bool = false
    @State var isEditing = false
    @State var reloadMyList = false
    @State private var refreshingID = UUID()
    @ObservedObject var listViewOfAvailableVerbsVM = ListViewOfAvailableVerbsVM(arrayIn: [UserVerbList]())
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    
    @FetchRequest(
        entity: UserVerbList.entity(),
        sortDescriptors: [NSSortDescriptor(key: "verbNameItalian", ascending: true)]
    ) var userCreatedVerbs: FetchedResults<UserVerbList>
    
    var editBtnTxt : String {
        
        if let isEditing = editMode?.wrappedValue.isEditing {
            return isEditing ? "Done" : "Edit"
        }else {
            return ""
        }
    }
    
    
    var body: some View {
        GeometryReader {geo in
            
            ZStack(alignment: .topLeading){
                Image("verticalNature")
                    .resizable()
                    .scaledToFill()
                //.padding(.bottom, 150)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                
                VStack{
                    HStack(spacing: 18){
                     
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 45))
                                .foregroundColor(.gray)
                                .padding(.trailing, 200)
                            
                            
                        }).padding(.leading, 20)
                        Spacer()
                        Image("italyFlag")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 55, height: 55)
                            .shadow(radius: 10)
                            .padding(.trailing, 20)
                      
                        
                    }
    
                }
                
                
                VStack(alignment: .leading){
                    Text("MyList")
                        .font(Font.custom("Chalkboard SE", size: 45))
                        .padding(.top, 60)
                        .offset(x: geo.size.width / 2.5 + 10)
                    
                    NavigationView{
                        VStack{
                            List{
                                let compactedArray: [UserVerbList] = listViewOfAvailableVerbsVM.fetchedUserAddedVerbs
                                ForEach(0..<compactedArray.count, id: \.self) {i in
                                    VStack{
                                        
                                        let vbItal = compactedArray[i].verbNameItalian ?? "defaultItal"
                                        
                                        let vbEngl = compactedArray[i].verbNameEnglish ?? "defaultEng"
                                        
                                        HStack{
                                            Text(vbItal + " - " + vbEngl)
                                                .font(.system(size: 30))
                                                .padding(10)
                                        }
                                    }
                                }
                                .onDelete(perform: removeRows)
                                .id(refreshingID)
                                
                            }.padding([.leading, .trailing], 40)
                            .frame(width: geo.size.width, height: geo.size.height * 0.6)
                            .overlay(Group {
                                if isEmptyMyListVerbData() {
                                    Text("Oops, loos like there's no data...")
                                }
                            })
                            // .navigationBarTitle("MyList")
                            .navigationBarItems(leading: HStack{
                                Button(action: {
                                    self.isEditing.toggle()
                                }, label: {
                                    Text(isEditing ? "Done" : "Edit")
                                        .font(Font.custom("Arial Hebrew", size: 30))
                                        .frame(width: 80, height: 40)
                                        .padding(.top, 20)
                                })
                            }, trailing: Button(action: onAdd) { Image(systemName: "plus").resizable().scaledToFill().padding(.trailing, 35).frame(width: 28, height: 28).offset(y:5)})
                            .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                            .padding(.top, 10)
                         
                            
                        }
                    }.frame(width: geo.size.width * 0.9, height: geo.size.height * 0.6) .cornerRadius(20)
                        .navigationViewStyle(.stack)
                        .padding([.leading, .trailing], geo.size.width * 0.05)
                      
                    
                    HStack{
                        
                        Button(action: {
                            showCreateVerb.toggle()
                        }, label: {
                            Text("Create Verb")
                                .font(Font.custom("Arial Hebrew", size: 35))
                                .padding(.top, 5)
                                .foregroundColor(.black)
                                .frame(width: 250, height: 60)
                                .background(Color("WashedWhite"))
                                .cornerRadius(20)
                                .overlay( RoundedRectangle(cornerRadius: 20)
                                    .stroke(.black, lineWidth: 2))
                                .shadow(radius: 10)
                                .padding(.top, 15)
                            
                        }).offset(x:200, y: 30)
                        
                    }.frame(width: 390, height: 50)
                    
                }
                
            }
            
        
            
            
        }.sheet(isPresented: $showingSheet, onDismiss: {
            viewContext.reset()
            loadData()
            self.refreshingID = UUID()}) {
            availableVerbsSheetIPAD()
        }
        .fullScreenCover(isPresented: $showCreateVerb) {
            CreateVerbTemplateIPAD()
        }
        .onAppear{
            if isEmptyMyListVerbData() {
                isEmpty = true
            }else{
                loadData()
            }
        }
        
    }
    
    private func removeRows(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach { i in
            viewContext.delete(listViewOfAvailableVerbsVM.fetchedUserAddedVerbs[i])
        }
        do {
            try viewContext.save()
        } catch {
            print("error saving")
        }
        
        listViewOfAvailableVerbsVM.objectWillChange.send()
        listViewOfAvailableVerbsVM.fetchedUserAddedVerbs.remove(atOffsets: offsets)
        //listViewOfAvailableVerbsVM.setFetchedData(arrayIn: availableVerbs)
        
    }
    
    private func onAdd() {
        showingSheet.toggle()
     }
    
    func loadData(){
        listViewOfAvailableVerbsVM.fetchedUserAddedVerbs = [UserVerbList]()
        for verbIn in userCreatedVerbs{
            listViewOfAvailableVerbsVM.objectWillChange.send()
            listViewOfAvailableVerbsVM.fetchedUserAddedVerbs.append(verbIn)
        }
    }
    
    func isEmptyMyListVerbData() -> Bool {
        
        let fR = UserVerbList.fetchRequest()
        
        do {
            let count = try viewContext.count(for: fR)
            if count == 0 {
                return true
            }else {
                return false
            }
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return false
        }
        
    }
    
}

struct availableVerbsSheetIPAD: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @FetchRequest(
        entity: UserAddedVerb.entity(),
        sortDescriptors: [NSSortDescriptor(key: "verbNameItalian", ascending: true)]
    ) var userCreatedVerbs: FetchedResults<UserAddedVerb>

    @State var availableVerbs: [verbObject] = []
    
    @State var showCreateVerb: Bool = false
    @State var showingSheet: Bool = false
    @State var listViewVerbs = [listViewVerbObject]()
    
    
    var body: some View{
        
        ZStack(alignment: .topLeading){
            VStack(spacing: 0){
                VStack(spacing: 0){
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.largeTitle)
                            .tint(Color.black)
                            .offset(x: -315, y: 10)
                        
                    }).padding(.bottom, 25)
                    Text("Choose from the available Italian verbs to add to your unique practice list!")
                        .font(Font.custom("Chalkboard SE", size: 20))
                        .multilineTextAlignment(.center)
                        .padding(15)
                        .frame(width: 340)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .overlay( RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth: 2))
                        .offset(y: -20)
                }.frame(width:800, height: 200)
                    .background(Color("pastelBlue"))
                List{
                    ForEach(0..<listViewVerbs.count, id: \.self) {i in
                        HStack{
                            Text(listViewVerbs[i].verbNameItalian + " - " + listViewVerbs[i].verbNameEnglish)
                                .font(.system(size: 25))
                            Spacer()
                            Toggle("", isOn: self.$listViewVerbs[i].isToggled)
                        }
                    }
                }.onAppear{
                    availableVerbs = verbObject.allVerbObject
                    addUsersVerbstoList()
                    listViewVerbs = createListViewObjects()
                }
                .padding(.top, 10)
                
                HStack{
                    
                    Button(action: {
                        for ver in listViewVerbs {
                            if ver.isToggled{
                                addNewUserAddedVerb(verbIn: ver)
                            }
                            
                        }
                    }, label: {
                        Text("Save")
                            .font(Font.custom("Arial Hebrew", size: 25))
                            .padding(.top, 5)
                            .foregroundColor(.black)
                            .frame(width: 140, height: 45)
                            .background(Color("WashedWhite"))
                            .cornerRadius(10)
                            .overlay( RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 3))
                            .shadow(radius: 10)
                            .padding(.top, 15)
                        
                    }).offset(x: 260, y: -820)
                        .padding(.leading, 10)
                    
                }.frame(width: 390, height: 50)
                
                
            }
            
        }
    }
    
    func addUsersVerbstoList(){
        
        for verbIn in userCreatedVerbs{
            availableVerbs.append(verbObject(verb: Verb(verbName: verbIn.verbNameItalian!, verbEngl: verbIn.verbNameEnglish!), presenteConjList: verbIn.presente!, passatoProssimoConjList: verbIn.passatoProssimo!, futuroConjList: verbIn.futuro!, imperfettoConjList: verbIn.imperfetto!, presenteCondizionaleConjList: verbIn.condizionale!, imperativoConjList: verbIn.imperativo!))
        }
        
    }
    
    func createListViewObjects()->[listViewVerbObject]{
        var tempArray:[listViewVerbObject] = [listViewVerbObject]()
        for verbObj in availableVerbs.unique(map: {$0.verb.verbName}) {
            tempArray.append(listViewVerbObject(verbNameItalian: verbObj.verb.verbName, verbNameEnglish: verbObj.verb.verbEngl, presentConjList: verbObj.presenteConjList, passatoProssimo: verbObj.passatoProssimoConjList, futuro: verbObj.futuroConjList, imperfetto: verbObj.imperfettoConjList, presCondizionale: verbObj.presenteCondizionaleConjList, imperativo: verbObj.imperativoConjList))
        }
        return tempArray
    }
    
    func addNewUserAddedVerb(verbIn: listViewVerbObject){
        
        let newUserAddedVerb = UserVerbList(context: viewContext)
        
        newUserAddedVerb.verbNameItalian = verbIn.verbNameItalian
        newUserAddedVerb.verbNameEnglish = verbIn.verbNameEnglish
        newUserAddedVerb.presente = verbIn.presentConjList
        newUserAddedVerb.passatoProssimo = verbIn.passatoProssimo
        newUserAddedVerb.futuro = verbIn.futuro
        newUserAddedVerb.imperfetto = verbIn.imperfetto
        newUserAddedVerb.condizionale = verbIn.presCondizionale
        newUserAddedVerb.imperativo = verbIn.imperativo
        
        do {
            try viewContext.save()
        } catch {
            print("error with save")
        }

    }
    
    struct listViewVerbObject: Identifiable{
        var id = UUID().uuidString
        var isToggled = false
        var verbNameItalian: String
        var verbNameEnglish: String
        var presentConjList: [String]
        var passatoProssimo: [String]
        var futuro: [String]
        var imperfetto: [String]
        var presCondizionale: [String]
        var imperativo: [String]
    }
    
}

struct ListViewOfAvailableVerbsIPAD_Previews: PreviewProvider {
    static var previews: some View {
        ListViewOfAvailableVerbsIPAD().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

