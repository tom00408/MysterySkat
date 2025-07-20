//
//  MysteryRamschenApp.swift
//  MysteryRamschen
//
//  Created by Tom Tiedtke on 16.07.25.
//

import SwiftUI
import Firebase

@main
struct MysteryRamschenApp: App {
    
    init() {
        // Firebase konfigurieren
        if FirebaseApp.app() == nil {
        FirebaseApp.configure()
        }
        
        // Firestore-Einstellungen
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        Firestore.firestore().settings = settings
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
