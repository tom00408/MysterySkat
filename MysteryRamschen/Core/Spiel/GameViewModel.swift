import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var currentRound: Int = 1
    @Published var currentPlayerIndex: Int = 0
    @Published var gamePhase: GamePhase = .dealing
    @Published var players: [String] = []
    @Published var currentPlayer: String = ""
    @Published var lobbyCode: String = ""
    @Published var playerCards: [String: [Card]] = [:]
    @Published var playedCards: [Card] = []
    @Published var currentTrick: [String: Card] = [:]
    
    private let spielmanager = SpielManager()
    
    enum GamePhase: String, CaseIterable {
        case dealing = "dealing"
        case playing = "playing"
        case roundComplete = "roundComplete"
        case gameComplete = "gameComplete"
    }
    
    struct Card: Identifiable, Equatable, Codable {
        let id = UUID()
        let suit: String
        let value: String
        let displayName: String
        
        init(suit: String, value: String) {
            self.suit = suit
            self.value = value
            self.displayName = "\(value) \(suit)"
        }
        
        enum CodingKeys: String, CodingKey {
            case suit, value, displayName
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            suit = try container.decode(String.self, forKey: .suit)
            value = try container.decode(String.self, forKey: .value)
            displayName = try container.decode(String.self, forKey: .displayName)
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(suit, forKey: .suit)
            try container.encode(value, forKey: .value)
            try container.encode(displayName, forKey: .displayName)
        }
    }
    
    init(lobbyViewModel: LobbyViewModel) {
        if let lobby = lobbyViewModel.currentLobby {
            self.players = lobby.players
            self.lobbyCode = lobby.id
            self.currentPlayer = players.first ?? ""
        }
        
        observeGameState()
    }
    
    private func observeGameState() {
        guard !lobbyCode.isEmpty else { return }
        
        spielmanager.observeGameState(code: lobbyCode) { gameState in
            DispatchQueue.main.async {
                self.updateFromGameState(gameState)
            }
        }
    }
    
    private func updateFromGameState(_ gameState: [String: Any]) {
        if let gamePhaseString = gameState["gamePhase"] as? String,
           let gamePhase = GamePhase(rawValue: gamePhaseString) {
            self.gamePhase = gamePhase
        }
        
        if let currentRound = gameState["currentRound"] as? Int {
            self.currentRound = currentRound
        }
        
        if let currentPlayerIndex = gameState["currentPlayerIndex"] as? Int {
            self.currentPlayerIndex = currentPlayerIndex
        }
        
        if let currentPlayer = gameState["currentPlayer"] as? String {
            self.currentPlayer = currentPlayer
        }
        
        if let playerCardsData = gameState["playerCards"] as? [String: [[String: String]]] {
            self.playerCards.removeAll()
            for (player, cardsData) in playerCardsData {
                let cards = cardsData.compactMap { cardData -> Card? in
                    guard let suit = cardData["suit"],
                          let value = cardData["value"] else { return nil }
                    return Card(suit: suit, value: value)
                }
                self.playerCards[player] = cards
            }
        }
        
        if let currentTrickData = gameState["currentTrick"] as? [String: [String: String]] {
            self.currentTrick.removeAll()
            for (player, cardData) in currentTrickData {
                if let suit = cardData["suit"],
                   let value = cardData["value"] {
                    self.currentTrick[player] = Card(suit: suit, value: value)
                }
            }
        }
    }
    
    func startGame() {
        gamePhase = .dealing
        currentPlayerIndex = 0
        currentRound = 1
        
        updateGameState()
        
        dealCards()
    }
    
    private func updateGameState() {
        guard !lobbyCode.isEmpty else { return }
        
        var gameState: [String: Any] = [
            "gamePhase": gamePhase.rawValue,
            "currentRound": currentRound,
            "currentPlayerIndex": currentPlayerIndex,
            "currentPlayer": currentPlayer
        ]
        
        var playerCardsData: [String: [[String: String]]] = [:]
        for (player, cards) in playerCards {
            playerCardsData[player] = cards.map { card in
                ["suit": card.suit, "value": card.value]
            }
        }
        gameState["playerCards"] = playerCardsData
        
        var currentTrickData: [String: [String: String]] = [:]
        for (player, card) in currentTrick {
            currentTrickData[player] = ["suit": card.suit, "value": card.value]
        }
        gameState["currentTrick"] = currentTrickData
        
        spielmanager.updateGameState(code: lobbyCode, gameState: gameState) { success in
            print(success ? "GameState aktualisiert" : "GameState Update fehlgeschlagen")
        }
    }
    
    private func dealCards() {
        let suits = ["♠", "♥", "♦", "♣"]
        let values = ["7", "8", "9", "10", "B", "D", "K", "A"]
        
        var allCards: [Card] = []
        for suit in suits {
            for value in values {
                allCards.append(Card(suit: suit, value: value))
            }
        }
        
        allCards.shuffle()
        
        playerCards.removeAll()
        for (index, player) in players.enumerated() {
            let startIndex = index * 10
            let endIndex = startIndex + 10
            let playerHand = Array(allCards[startIndex..<endIndex])
            playerCards[player] = playerHand
        }
        
        updateGameState()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gamePhase = .playing
            self.updateCurrentPlayer()
            self.updateGameState()
        }
    }
    
    func playCard(_ card: Card, for player: String) {
        guard gamePhase == .playing && currentPlayer == player else { return }
        
        if var playerHand = playerCards[player] {
            playerHand.removeAll { $0.id == card.id }
            playerCards[player] = playerHand
        }
        
        currentTrick[player] = card
        playedCards.append(card)
        
        updateGameState()
        
        nextPlayer()
    }
    
    func nextPlayer() {
        currentPlayerIndex += 1
        
        if currentPlayerIndex >= players.count {
            currentPlayerIndex = 0
            
            if playedCards.count >= players.count * 10 {
                gamePhase = .roundComplete
                updateGameState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.startNextRound()
                }
            } else {
                currentTrick.removeAll()
                updateCurrentPlayer()
                updateGameState()
            }
        } else {
            updateCurrentPlayer()
            updateGameState()
        }
    }
    
    private func startNextRound() {
        currentRound += 1
        currentPlayerIndex = 0
        playedCards.removeAll()
        currentTrick.removeAll()
        updateGameState()
        dealCards()
    }
    
    private func updateCurrentPlayer() {
        if currentPlayerIndex < players.count {
            currentPlayer = players[currentPlayerIndex]
        }
    }
    
    func isCurrentPlayer(_ playerName: String) -> Bool {
        return currentPlayer == playerName
    }
    
    func getPlayerCards(_ playerName: String) -> [Card] {
        return playerCards[playerName] ?? []
    }
    
    func getCurrentTrick() -> [String: Card] {
        return currentTrick
    }
    
    func getTrickCount() -> Int {
        return playedCards.count / players.count
    }
} 


extension GameViewModel.Card {
    var suitName: String {
        switch suit {
        case "♥": return "herz"
        case "♦": return "karo"
        case "♠": return "pik"
        case "♣": return "kreuz"
        default: return "?"
        }
    }

    var valueName: String {
        return value
    }
}
