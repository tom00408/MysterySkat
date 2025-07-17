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
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
           
        
        WindowGroup {
            ContentView()
        }
    }
}
