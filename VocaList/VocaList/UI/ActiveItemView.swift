// 20250608
// ActiveItemView

import SwiftUI
import SwiftData

struct ActiveItemView: View {
    
    // MARK: - VARIABLES
    @Environment(\.modelContext) private var context
    let item: Item
    let showDragHandle: Bool
    
    init(item: Item, showDragHandle: Bool = true) {
        self.item = item
        self.showDragHandle = showDragHandle
    }
    
    // MARK: - BODY
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .medium))
            } /* VStack */
            
            Spacer()
            
            VStack {
                Text("Created \(item.createdAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                // Conditionally show drag handle
                if showDragHandle {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .frame(width: 20)
                }
            }
            
        } /* HStack */
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            // Swipe from right edge to complete/uncomplete
            Button {
                toggleCompletion()
            } label: {
                Label(
                    "Complete",
                    systemImage: "checkmark.circle"
                )
            }
            .tint(.green)
        }
    }
    
    // MARK: - FUNCTIONS
    private func toggleCompletion() {
        withAnimation {
            item.isCompleted.toggle()
            item.completedAt = Date()
            try? context.save()
        }
    }
}
