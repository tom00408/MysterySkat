import Foundation
import SwiftUI

class LobbyViewModel: ObservableObject {
    @Published var lobbyCode: String = ""
    @Published var hostName: String = ""
    @Published var currentLobby: Spiel?
    @Published var gameStarted: Bool = false

    private let spielmanager = SpielManager()
    
    init() {
        self.hostName = UIDevice.current.name
    }
    
    var istHost: Bool {
        return currentLobby?.host == hostName
    }

    init(hostName: String) {
        self.hostName = hostName
    }

    func createLobbyTest(completion: @escaping (Bool) -> Void = { _ in }) {
        print("Starte Lobby-Erstellung für \(hostName)")
        self.lobbyCode = ""
        self.currentLobby = nil
        self.gameStarted = false
        
        spielmanager.createLobby(hostname: hostName) { code in
            DispatchQueue.main.async {
                if let code = code {
                    self.lobbyCode = code
                    self.observeLobby(code: code)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func joinLobby(code: String, completion: @escaping (Bool) -> Void = { _ in }) {
        spielmanager.joinLobby(withCode: code, playerName: hostName) { success in
            DispatchQueue.main.async {
                if success {
                    self.lobbyCode = code
                    self.observeLobby(code: code)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func observeLobby(code: String) {
        spielmanager.observeLobby(code: code) { lobby in
            DispatchQueue.main.async {
                self.currentLobby = lobby
                
                // Prüfe, ob das Spiel gestartet wurde
                if lobby.status == "started" {
                    self.gameStarted = true
                }
            }
        }
    }

    func startGame() {
        guard let code = currentLobby?.id else { return }
        spielmanager.updateStatus(for: code, to: "started") { success in
            print(success ? "Spiel gestartet" : "Start fehlgeschlagen")
        }
    }
}
