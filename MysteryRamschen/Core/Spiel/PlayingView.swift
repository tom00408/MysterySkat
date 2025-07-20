import SwiftUI

struct PlayingView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let playerName: String
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Text("Runde \(gameViewModel.currentRound)")
                
                Text("Stich \(gameViewModel.getTrickCount() + 1) von 10")
                    
            }
            
            VStack(spacing: 10) {
                if gameViewModel.isCurrentPlayer(playerName) {
                    Text("Du bist dran!")
                } else {
                    Text("\(gameViewModel.currentPlayer) ist dran")
                }
            }
            
            VStack(spacing: 15) {
                Text("Aktueller Stich:")
                    .font(.headline)
                
                if gameViewModel.getCurrentTrick().isEmpty {
                    Text("Noch keine Karten gelegt")
                        .foregroundColor(.secondary)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                        ForEach(Array(gameViewModel.getCurrentTrick().keys.sorted()), id: \.self) { player in
                            if let card = gameViewModel.getCurrentTrick()[player] {
                                VStack(spacing: 2) {
                                    Text(player)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    CardView(
                                        card: card,
                                        isPlayable: false
                                    ) {
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.blue.opacity(0.05))
            .cornerRadius(12)
            
            VStack(spacing: 10) {
                Text("Deine Karten (\(gameViewModel.getPlayerCards(playerName).count)):")
                    .font(.headline)
                
                if gameViewModel.isCurrentPlayer(playerName) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
                        ForEach(gameViewModel.getPlayerCards(playerName)) { card in
                            CardView(
                                card: card,
                                isPlayable: true
                            ) {
                                gameViewModel.playCard(card, for: playerName)
                            }
                        }
                    }
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
                        ForEach(gameViewModel.getPlayerCards(playerName)) { card in
                            CardView(
                                card: card,
                                isPlayable: false
                            ) {
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.green.opacity(0.05))
            .cornerRadius(12)
            
            Spacer()
        }
        .padding()
        .navigationTitle("MYSERTY SKAT")
        .navigationBarTitleDisplayMode(.inline)
    }
}

