//
//  Spiel.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 16.07.25.
//

import Foundation

class Spiel : Codable, Identifiable{
    
    let id: String
    var spielerIds: [String]
    
    
    init(id : String) {
        self.id = id
        self.spielerIds = []
    }
    
    
    
    
    
    
}
