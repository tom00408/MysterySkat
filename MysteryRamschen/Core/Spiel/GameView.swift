import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: LobbyViewModel
    @StateObject private var gameViewModel: GameViewModel
    
    init(viewModel: LobbyViewModel) {
        self.viewModel = viewModel
        self._gameViewModel = StateObject(wrappedValue: GameViewModel(lobbyViewModel: viewModel))
    }

    var body: some View {
        Group {
            switch gameViewModel.gamePhase {
            case .dealing:
                DealingView(
                    gameViewModel: gameViewModel,
                    playerName: viewModel.hostName
                )
            case .playing:
                PlayingView(
                    gameViewModel: gameViewModel,
                    playerName: viewModel.hostName
                )
            case .roundComplete:
                RoundCompleteView(
                    gameViewModel: gameViewModel,
                    playerName: viewModel.hostName
                )
            case .gameComplete:
                GameCompleteView(
                    gameViewModel: gameViewModel,
                    playerName: viewModel.hostName
                )
            }
        }
        .navigationTitle("Skat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            if gameViewModel.gamePhase == .dealing {
                           gameViewModel.startGame()
            }
        }
    }
}

#Preview {
    GameView(viewModel: LobbyViewModel(hostName: "TestHost"))
}
