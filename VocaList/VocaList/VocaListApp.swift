//
//  VocaListApp.swift
//  VocaList
//
//  Created by rishabh b on 6/10/25.
//

import SwiftUI
import SwiftData



@main
struct VocaListApp: App {
    let container = try! ModelContainer(for: Item.self)
    
    init() {
            // Print SQLite command on app launch
        let tempContext = ModelContext(container)
            print("SQLite command: \(tempContext.sqliteCommand)")
        }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(container) // Creates the DB
    }
}

// Add this extension right here in the same file
extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
