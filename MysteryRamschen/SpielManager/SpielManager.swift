import Foundation
import Firebase
import FirebaseFirestore

class SpielManager: ObservableObject{
    
    let db = Firestore.firestore()
    
    func createLobby(hostname: String, completion: @escaping (String?) -> Void){
        let lobbyCode = String(UUID().uuidString.prefix(4)).uppercased()
        print("Versuche Lobby zu erstellen mit Code: \(lobbyCode) und Host: \(hostname)")

        let lobby = Spiel(id: lobbyCode,
                          players: [hostname],
                          status: "open",
                          host: hostname)

        do {
            try db.collection("spiele").document(lobbyCode).setData(from: lobby) { error in
                if let error = error {
                    print("❌ Fehler beim Schreiben in Firestore: \(error)")
                    completion(nil)
                } else {
                    print("Lobby erstellt mit Code: \(lobbyCode)")
                    completion(lobbyCode)
                }
            }
        } catch {
            print("Codierungsfehler: \(error)")
            completion(nil)
        }
    }

    
    func joinLobby(withCode code: String, playerName: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("spiele").document(code)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var lobby = try? document.data(as: Spiel.self)
                guard var currentLobby = lobby else { return }

                if currentLobby.status != "open" || currentLobby.players.contains(playerName) {
                    completion(false)
                    return
                }

                currentLobby.players.append(playerName)

                try? docRef.setData(from: currentLobby) { error in
                    completion(error == nil)
                }
            } else {
                completion(false)
            }
        }
    }

    
    func observeLobby(code: String, onUpdate: @escaping (Spiel) -> Void) {
        db.collection("spiele").document(code).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Fehler beim Beobachten: \(error?.localizedDescription ?? "")")
                return
            }

            if let lobby = try? document.data(as: Spiel.self) {
                onUpdate(lobby)
            }
        }
    }

    func updateStatus(for code: String, to newStatus: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("spiele").document(code)

        docRef.updateData([
            "status": newStatus
        ]) { error in
            if let error = error {
                print("Fehler beim Status-Update: \(error)")
                completion(false)
            } else {
                print("Status erfolgreich geändert auf \(newStatus)")
                completion(true)
            }
        }
    }

}
