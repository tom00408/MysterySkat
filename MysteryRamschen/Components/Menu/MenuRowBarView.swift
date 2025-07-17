//
//  MenuRowBarView.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 16.07.25.
//

import SwiftUI

struct MenuRowBarView: View {
    
    let text : String
    
    var body: some View {
        VStack{
            Text(text)
        }
        .padding()
        .background {
            Rectangle().fill(Color.gray.opacity(0.4))
        }

    }
}

#Preview {
    MenuRowBarView(text: "Neues Spiel erstellen!")
}
