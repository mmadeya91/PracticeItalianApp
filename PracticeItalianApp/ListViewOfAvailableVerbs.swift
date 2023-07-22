//
//  ListViewOfAvailableVerbs.swift
//  PracticeItalianApp
//
//  Created by Matt Madeya on 7/3/23.
//

import SwiftUI
import Algorithms

final class ListViewOfAvailableVerbsVM: ObservableObject{
    @Published var fetchedUserAddedVerbs: [UserVerbList]
    
    init(arrayIn: [UserVerbList]){
        fetchedUserAddedVerbs = arrayIn
    }
    
    func setFetchedData(arrayIn: [UserVerbList]){
        fetchedUserAddedVerbs = arrayIn
    }
}


struct ListViewOfAvailableVerbs: View {
    
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
        VStack(alignment: .leading){
            HStack(spacing: 18){
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                    
                    
                })
                
            }.padding(.bottom, 25)
            
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
                                    }
                                }
                            }
                            .onDelete(perform: removeRows)
                            .id(refreshingID)
                            
                        }
                        .overlay(Group {
                            if isEmptyMyListVerbData() {
                                Text("Oops, loos like there's no data...")
                            }
                        })
                        .navigationBarTitle("MyList")
                        .navigationBarItems(leading: HStack{
                            Button(action: {
                                self.isEditing.toggle()
                            }, label: {
                                Text(isEditing ? "Done" : "Edit")
                                    .frame(width: 80, height: 40)
                            })
                        }, trailing: Button(action: onAdd) { Image(systemName: "plus") })
                        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                        .padding(.top, 20)
                }
            }
            
            
            HStack{
                
                Button(action: {
                    showCreateVerb.toggle()
                }, label: {
                    Text("Create Verb")
                    
                })
                
            }.frame(width: 300)
                .background(.white)
            
            
            
        }.sheet(isPresented: $showingSheet, onDismiss: {
            viewContext.reset()
            loadData()
            self.refreshingID = UUID()}) {
            availableVerbsSheet()
        }
        .fullScreenCover(isPresented: $showCreateVerb) {
            CreateVerbTemplate()
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

struct availableVerbsSheet: View {
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
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                    .tint(Color.black)
                
            }).padding().zIndex(1)
            
            VStack{
                Text("Choose from the available Italian verbs to add to your unique practice list!")
                    .font(Font.custom("Chalkboard SE", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(15)
                    .frame(width: 340)
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding(.top, 65)
                List{
                    ForEach(0..<listViewVerbs.count, id: \.self) {i in
                        HStack{
                            Text(listViewVerbs[i].verbNameItalian + " - " + listViewVerbs[i].verbNameEnglish)
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
                
                Button(action: {
                    for ver in listViewVerbs {
                        if ver.isToggled{
                            addNewUserAddedVerb(verbIn: ver)
                        }
                        
                    }
                }, label: {
                    Text("Save")
                    
                })
                
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

struct ListViewOfAvailableVerbs_Previews: PreviewProvider {
    static var previews: some View {
        ListViewOfAvailableVerbs().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
