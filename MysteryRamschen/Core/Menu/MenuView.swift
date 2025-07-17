//
//  MenuView.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 16.07.25.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        
        NavigationStack{
            VStack(spacing: 30){
                NavigationLink {
                    SpielErstellenView()
                } label: {
                    MenuRowBarView(text: "🆕Neues Spiel erstellen")
                }
                NavigationLink{
                    SpielBeitretenView()
                } label: {
                    MenuRowBarView(text: "Einem Spiel beitreten➡️")
                }
                
                MenuRowBarView(text: "Einstellungen ⚙️")
            }

            
            
        }
        
    }
}

#Preview {
    MenuView()
}
