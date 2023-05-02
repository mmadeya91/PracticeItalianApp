//
//  JSONManager.swift
//  PracticeItalianApp
//
//  Created by Matthew Madeya on 4/26/23.
//

import Foundation

struct verbObject: Codable {
    var verb: Verb
    var presenteConjList, passatoProssimoConjList, futuroConjList, imperfettoConjList: [String]
    var presenteCondizionaleConjList, imperativoConjList: [String]
    
    static let allVerbObject: [verbObject] = Bundle.main.decode(file: "ItalianAppVerbData.json")
    
    
}
    

struct Verb: Codable {
    var verbName, verbEngl: String
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project!")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project!")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Culd not decode \(file) in the project!")
        }
        
        return loadedData
    }
}
