//
//  SpielErstellenView.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 16.07.25.
//

import SwiftUI

struct SpielErstellenView: View {
    
    
    var spielManager = SpielManager()
    var gameData : String
    
    
    
    private var spielErstellt : Bool = false
    
    
    init(){
        self.gameData = spielManager.getGameData()
        self.spielErstellt = true
    }
    
    
    var body: some View {
        if spielErstellt {
            Text("ID: \(self.gameData)")
        }else{
            Text("Laden")
        }
        
        
        
    }
}

#Preview {
    SpielErstellenView()
}
