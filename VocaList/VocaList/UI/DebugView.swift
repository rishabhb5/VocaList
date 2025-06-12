//
//  DebugView.swift
//  VocaList
//
//  Created by rishabh b on 6/12/25.
//

import SwiftUI
import SwiftData

struct DebugView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]
    
    var body: some View {
        NavigationView {
            List(items) { item in
                Text(item.title)
            }
            .navigationTitle("Debug: All Items")
        }
    }
}
