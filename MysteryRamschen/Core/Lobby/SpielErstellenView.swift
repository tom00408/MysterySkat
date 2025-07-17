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
        
        
        Text("id: \(gameData)")
        
        NavigationStack{
            
            
            NavigationLink{
                GameView()
            }label: {
                Text("STARTEN")
                    .padding()
                    .background{
                        Rectangle()
                            .fill(.green)
                    }
            }
            
        }
        
    }
}

#Preview {
    SpielErstellenView()
}
