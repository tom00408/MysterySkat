//
//  SpielManager.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 16.07.25.
//

import Foundation
import Firebase
import FirebaseFirestore

class SpielManager: ObservableObject{
    
    let db = Firestore.firestore()
    
    init(){
        
    }
    
    func getGameData() -> String{
        
        let spiel = Spiel(id: createSpielID())
        
        do{
            
            
            try   db.collection("games").document(spiel.id).setData(from: spiel)
            return spiel.id
        }catch{
            print("spiel konnte nicht erstellt werden")
            return "MISSLUNGEN"
        }
    }
    
    
    
    
    
        func createSpielID() -> String {
            let templateCodes = ["pinguin","giraffe","bro","panda","amsti","merkur","holland","jacks","BadBendheim","Hannover","dominos","sonntag","doko","mystery"]
            guard let randomWord = templateCodes.randomElement() else {
                return "KeinWortGefunden"
            }
            let randomNumber = Int.random(in: 1...1000)
            return "\(randomWord)\(randomNumber)"
        }
    
}
