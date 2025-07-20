import SwiftUI

struct GameCompleteView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let playerName: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Spiel beendet!")
            Text("Alle Runden wurden gespielt")
                
            
            VStack(spacing: 15) {
                Text("Spieler-Übersicht:")
                
                ForEach(gameViewModel.players, id: \.self) { player in
                    HStack {
                        Text("\(player)")
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
    }
}
