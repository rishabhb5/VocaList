// 20250612
// ActiveView

import SwiftUI
import SwiftData

struct ActiveView: View {
    // MARK: - VARIABLES
    
    // Insert, Delete, Save (CRUD operations)
    @Environment(\.modelContext) private var context
    @StateObject var whisperState = WhisperState()
        
//    @Query(
//        filter: #Predicate<Item> { $0.isCompleted == false },
//        sort: [SortDescriptor(\Item.completedAt, order: .reverse)]
//    ) private var activeItemsList: [Item]
    
    // var alItemList: Fetches data from the DB, updates UI reactively when data changes
    // // Querying all Items
    @Query(sort: [SortDescriptor(\Item.sortOrder),
                  SortDescriptor(\Item.createdAt, order:.reverse)]) private var allItemsList:[Item]
    
    // Filtering for only Active items (isCompleted = false)
    private var activeItemsList: [Item] {
        allItemsList.filter { !$0.isCompleted}
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    if activeItemsList.isEmpty {
                        ContentUnavailableView {
                            Label("No Active Items", systemImage: "checklist")
                        } description: {
                            Text("Click '+' to add a new item or check check Completed tab")
                        }
                    } else {
                        ForEach(activeItemsList) { item in
                            ActiveItemView(item: item)
                        }
                        .onDelete(perform: deleteItem) // Swift handles the index (no need to pass in)
                        .onMove(perform: moveItem) // Swift handles the index (no need to pass in)
                    }
                }
                .navigationTitle("Active Items")
                .navigationBarTitleDisplayMode(.inline)
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        RecordButton(whisperState: whisperState)
                            .padding(.trailing, 16)
                            .padding(.bottom, 16)
                    }
                }
            }
            .onChange(of: whisperState.isRecording) { oldValue, newValue in
                // Only save when recording stops (was true, now false)
                if oldValue == true && newValue == false {
                    // Add a small delay to let transcription complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if (whisperState.recordedText != "[BLANK_AUDIO]") {
                            let newItem = Item(title: whisperState.recordedText)
                            // Set sortOrder to 0 to make it appear at the top
                            newItem.sortOrder = 0
                            // Update sortOrder for all existing items
                            for item in activeItemsList {
                                item.sortOrder += 1
                            }
                            
                            context.insert(newItem)
                            
                            do {
                                try context.save()
                                print("Saved item: \(whisperState.recordedText)")
                            } catch {
                                print("Failed to save item: \(error)")
                            }
                        }

                    }
                }
            } /* onChange */
        } /* NavigationView */
    } /* body */
    
    // MARK: - PRIVATE FUNCTIONS
    private func deleteItem(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                context.delete(activeItemsList[index])
            }
            
            // Save Changes
            try? context.save()
        }
    } /* deleteItem() */
    
    private func moveItem(from source: IndexSet, to destination: Int) {
        var updatedItems = Array(activeItemsList)
        updatedItems.move(fromOffsets: source, toOffset: destination)
        
        // Update sort order for all items
        for (index, item) in updatedItems.enumerated() {
            item.sortOrder = index
        }
        
        // Save Changes
        do {
            try context.save()
        } catch {
            print("Failed to save reordered items: \(error)")
        }
    } /* moveItem() */
    
} /* ActiveView */

// Separate view for the record button
struct RecordButton: View {
    @ObservedObject var whisperState: WhisperState
    
    var body: some View {
        Button(action: {}) {
            Text(whisperState.isRecording ? "Recording..." : "Hold to Record")
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(width: 80, height: 80)
        .background(whisperState.isRecording ? Color.red : Color.purple)
        .clipShape(Circle())
        .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
        .disabled(!whisperState.canTranscribe)
        .scaleEffect(whisperState.isRecording ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: whisperState.isRecording)
        .onLongPressGesture(
            minimumDuration: 0.0,
            maximumDistance: .infinity,
            perform: {
                // This fires when the long press ends
            },
            onPressingChanged: { pressing in
                if pressing {
                    // User started pressing - start recording
                    if !whisperState.isRecording {
                        Task {
                            await whisperState.toggleRecord()
                        }
                    }
                } else {
                    // User released - stop recording
                    if whisperState.isRecording {
                        Task {
                            await whisperState.toggleRecord()
                        }
                    }
                }
            }
        )
    }
}

