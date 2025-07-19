import SwiftUI

struct SpielBeitretenView: View {
    let playerName: String
    @State private var lobbyCode = ""
    @State private var navigateToLobby = false
    @State private var joinFailed = false
    @State private var isLoading = false
    @State private var lobbyViewModel: LobbyViewModel?

    var body: some View {
        VStack(spacing: 20) {
            Text("Spieler: \(playerName)")
                .font(.headline)
            
            TextField("Lobby-Code eingeben", text: $lobbyCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.characters)
                .disabled(isLoading)

            Button("Lobby beitreten") {
                joinLobby()
            }
            .disabled(lobbyCode.isEmpty || isLoading)
            .buttonStyle(.borderedProminent)

            if isLoading {
                ProgressView("Beitrete Lobby...")
            }

            if joinFailed {
                Text("Beitritt fehlgeschlagen - Überprüfe den Code")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Lobby beitreten")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToLobby) {
            if let viewModel = lobbyViewModel {
                LobbyView(viewModel: viewModel)
            }
        }
    }
    
    private func joinLobby() {
        guard !lobbyCode.isEmpty else { return }
        
        isLoading = true
        joinFailed = false
        
        let viewModel = LobbyViewModel(hostName: playerName)
        viewModel.joinLobby(code: lobbyCode.uppercased()) { success in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    viewModel.lobbyCode = lobbyCode.uppercased()
                    self.lobbyViewModel = viewModel
                    self.navigateToLobby = true
                } else {
                    joinFailed = true
                }
            }
        }
    }
}

#Preview {
    SpielBeitretenView(playerName: "TestSpieler")
}
