import SwiftUI
import AVFoundation
import Foundation

struct ActiveView: View {
    // MARK: - VARIABLES
    @Environment(\.modelContext) private var context
    @StateObject var whisperState = WhisperState()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Testing")
                
                Button(whisperState.isRecording ? "Stop recording" : "Start recording", action: {
                    Task {
                        await whisperState.toggleRecord()
                    }                    
                })
                .buttonStyle(.bordered)
                .disabled(!whisperState.canTranscribe)
                
            }
            .navigationTitle("Voice List Demo")
            .padding()
            .onChange(of: whisperState.isRecording) { oldValue, newValue in
                // Only save when recording stops (was true, now false)
                if oldValue == true && newValue == false {
                    // Add a small delay to let transcription complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let newItem = Item(title: whisperState.recordedText)
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
        }
    }
}
