//
//  GameView.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 17.07.25.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: LobbyViewModel
    
    init(viewModel: LobbyViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("MYSTERY SKAT")
                .font(.largeTitle)
                .bold()
            
            
            if let lobby = viewModel.currentLobby {
                Text("Spieler (\(lobby.players.count)):")
                    .font(.headline)
                    .padding(.top)
                
                VStack(spacing: 10) {
                    ForEach(lobby.players, id: \.self) { player in
                        HStack {
                            Text("\(player)")
                                .font(.body)
                            
                            Spacer()
                            
                            if player == lobby.host {
                                Text("(Host)")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(4)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Spiel")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    GameView(viewModel: LobbyViewModel(hostName: "TestHost"))
}
