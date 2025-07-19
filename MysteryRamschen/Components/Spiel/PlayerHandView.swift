//
//  PlayerHandView.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 17.07.25.
//

import SwiftUI

struct PlayerHandView: View {
    @State var cards = ["pik7", "pik8", "pik9", "pik10", "pikB","kreuzB","herzB", "kreuzA","kreuz7","kreuz8"]
    
    var body: some View {
        ZStack {
            ForEach(cards.indices, id: \.self) { index in
                Button{
                    print(cards[index])
                    //cards.remove(at: index)
                    
                }label:{
                    Image(cards[index])
                        .resizable()
                        .font(.system(size: 60))
                        .frame(width: 120, height: 140)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                         
                    
                }.offset(x: CGFloat(index) * 35)
            }
        }.offset(x: -25 * CGFloat(cards.count) / 2)
        .frame(height: 150)
    }
}

#Preview {
    PlayerHandView()
}
