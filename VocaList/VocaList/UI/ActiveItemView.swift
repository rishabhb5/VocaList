// 20250608
// ActiveItemView - Card Style

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
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                // Date badge
                Text("Jun 8")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Color.purple.opacity(0.6)
                    )
                    .cornerRadius(6)
                
                // Conditionally show drag handle
                if showDragHandle {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(Color.purple.opacity(0.8))
                        .font(.system(size: 16))
                        .frame(width: 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            // Card gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.12, green: 0.12, blue: 0.12), // #1f1f1f
                    Color(red: 0.29, green: 0.17, blue: 0.35)  // #4a2c5a
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            // Purple left border
            Rectangle()
                .fill(Color(red: 0.54, green: 0.17, blue: 0.89)) // #8a2be2
                .frame(width: 4)
                .cornerRadius(2),
            alignment: .leading
        )
        .cornerRadius(0) // Remove rounded corners to fill entire row
        .shadow(
            color: Color(red: 0.54, green: 0.17, blue: 0.89).opacity(0.3), // Purple shadow
            radius: 10,
            x: 0,
            y: 4
        )
        .contentShape(Rectangle())
        .listRowBackground(Color.clear) // Remove default row background
        .listRowSeparator(.visible) // Show separators
        .listSectionSeparator(.hidden) // Hide section separators if any
        .listRowSeparatorTint(Color(.black)) // Dark purple separator
        .listRowInsets(EdgeInsets()) // Remove all default insets - fills entire row
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.2), value: false) // For hover-like effects
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
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

//// 20250608
//// ActiveItemView
//
//import SwiftUI
//import SwiftData
//
//struct ActiveItemView: View {
//    
//    // MARK: - VARIABLES
//    @Environment(\.modelContext) private var context
//    let item: Item
//    let showDragHandle: Bool
//    
//    init(item: Item, showDragHandle: Bool = true) {
//        self.item = item
//        self.showDragHandle = showDragHandle
//    }
//    
//    // MARK: - BODY
//    var body: some View {
//        HStack(spacing: 12) {
//            VStack(alignment: .leading, spacing: 4) {
//                Text(item.title)
//                    .foregroundColor(.primary)
//                    .font(.system(size: 16, weight: .medium))
//            } /* VStack */
//            
//            Spacer()
//            
//            VStack {
//                Text("Created \(item.createdAt.formatted(date: .abbreviated, time: .omitted))")
//                    .font(.system(size: 10))
//                    .foregroundColor(.secondary)
//                
//                // Conditionally show drag handle
//                if showDragHandle {
//                    Image(systemName: "line.3.horizontal")
//                        .foregroundColor(.gray)
//                        .font(.system(size: 16))
//                        .frame(width: 20)
//                }
//            }
//            
//        } /* HStack */
//        .padding(.vertical, 4)
//        .contentShape(Rectangle())
//        .swipeActions(edge: .leading, allowsFullSwipe: true) {
//            // Swipe from right edge to complete/uncomplete
//            Button {
//                toggleCompletion()
//            } label: {
//                Label(
//                    "Complete",
//                    systemImage: "checkmark.circle"
//                )
//            }
//            .tint(.green)
//        }
//    }
//    
//    // MARK: - FUNCTIONS
//    private func toggleCompletion() {
//        withAnimation {
//            item.isCompleted.toggle()
//            item.completedAt = Date()
//            try? context.save()
//        }
//    }
//}
