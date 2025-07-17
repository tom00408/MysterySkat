//
//  PlayerHandView.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 17.07.25.
//

import SwiftUI

struct PlayerHandView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text("Test Moin Moin")
        
        NavigationStack{
            NavigationLink{
                SpielErstellenView()
            }label: {
                Text("Zurück")
                    .padding()
                    .background{
                        Rectangle()
                            .fill(.red)
            }
            }
        }
        
    }
}

#Preview {
    PlayerHandView()
}
