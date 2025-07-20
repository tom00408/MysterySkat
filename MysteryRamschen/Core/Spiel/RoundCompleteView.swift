import SwiftUI

struct RoundCompleteView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let playerName: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Runde \(gameViewModel.currentRound - 1) abgeschlossen!")
            
            Text("Alle 10 Stiche wurden gespielt")
            
            VStack(spacing: 15) {
                Text("Nächste Runde startet in:")
                
                Text("3 Sekunden")
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
    }
}
