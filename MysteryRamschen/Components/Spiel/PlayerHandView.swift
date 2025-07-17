//
//  PlayerHandView.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 17.07.25.
//

import SwiftUI

struct PlayerHandView: View {
    let cards = ["pik7", "pik8", "pik9", "pikT", "pikB"] // Platzhalter-Symbole
    
    var body: some View {
        ZStack {
            ForEach(cards.indices, id: \.self) { index in
                Button{
                    print(cards[index])
                }label:{
                    Image(cards[index])
                        .resizable()
                        .font(.system(size: 60))
                        .frame(width: 80, height: 120)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                         // ← Abstand der Karten
                    
                }.offset(x: CGFloat(index) * 30)
            }
        }
        .frame(height: 150)
    }
}

#Preview {
    PlayerHandView()
}
