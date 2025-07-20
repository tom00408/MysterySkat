import SwiftUI

struct LobbyView: View {
    @ObservedObject var viewModel: LobbyViewModel
    @State private var navigateToGame = false

    var body: some View {
        VStack(spacing: 20) {
            if let lobby = viewModel.currentLobby {
                VStack(spacing: 15) {
                    Text("Lobby-Code: \(lobby.id)")
                        .font(.headline)
                    
                Text("Host: \(lobby.host)")
                        .font(.subheadline)
                    
                    Text("Spieler (\(lobby.players.count)):")
                        .font(.headline)
                        .padding(.top)
                    
                ForEach(lobby.players, id: \.self) { player in
                        HStack {
                            Text("• \(player)")
                            if player == lobby.host {
                                Text("(Host)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                }

                if viewModel.hostName == lobby.host {
                    Button("Spiel starten") {
                        viewModel.startGame()
                    }
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                } else {
                        Text("Warte auf den Host...")
                            .foregroundColor(.secondary)
                            .padding(.top)
                    }
                }
            } else if !viewModel.lobbyCode.isEmpty {
                VStack(spacing: 15) {
                    Text("Lobby-Code:")
                        .font(.headline)
                    
                    Text(viewModel.lobbyCode)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    
                    ProgressView("Lobby wird geladen...")
                        .padding(.top)
                }
                } else {
                VStack(spacing: 15) {
                    ProgressView("Lobby wird erstellt...")
                        .padding()
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Lobby")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToGame) {
            GameView(viewModel: viewModel)
        }
        .onAppear {
            if viewModel.lobbyCode.isEmpty {
                viewModel.createLobbyTest()
            } else {
                viewModel.observeLobby(code: viewModel.lobbyCode)
            }
        }
        .onChange(of: viewModel.gameStarted) { gameStarted in
            if gameStarted {
                navigateToGame = true
            }
        }
    }
}

#Preview {
    LobbyView(viewModel: LobbyViewModel(hostName: "TestHost"))
}
