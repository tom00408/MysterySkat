import SwiftUI

struct DealingView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let playerName: String
    
    var body: some View {
        VStack(spacing: 30) {
            Text("🃏")
                .font(.system(size: 60))
            
            Text("Karten werden verteilt...")
                .font(.title)
                .bold()
                .foregroundColor(.blue)
            
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Jeder Spieler bekommt 10 Karten")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
    }
}
