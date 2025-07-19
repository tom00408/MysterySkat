import SwiftUI

struct MenuView: View {
    @State private var hostName: String = ""
    @State private var navigateToCreate = false
    @State private var navigateToJoin = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                TextField("Dein Name", text: $hostName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                
                Button(action: {
                    navigateToCreate = true
                }) {
                    Text("Lobby erstellen")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(hostName.isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .contentShape(Rectangle())
                }
                .disabled(hostName.isEmpty)
                .padding(.horizontal)

                
                Button("Lobby beitreten") {
                    navigateToJoin = true
                }
                .disabled(hostName.isEmpty)

                NavigationLink {
                    SettingView()
                } label: {
                    MenuRowBarView(text: "Einstellungen")
                }

                Spacer()
            }
            .padding()
            .navigationTitle("MYSTERY SKAT")
            .navigationDestination(isPresented: $navigateToCreate) {
                LobbyView(viewModel: LobbyViewModel(hostName: hostName))
            }
            .navigationDestination(isPresented: $navigateToJoin) {
                SpielBeitretenView(playerName: hostName)
            }
        }
    }
}

#Preview{
    MenuView()
}
