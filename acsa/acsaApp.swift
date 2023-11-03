//
//  acsaApp.swift
//  acsa
//
//  Created by Denzel Nyatsanza on 10/31/23.
//

import SwiftUI
import Firebase

@main
struct acsaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
