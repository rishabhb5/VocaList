// 20250605
// MainTabView

import SwiftUI

struct MainTabView: View {
    
    // MARK: - BODY
    var body: some View {
        TabView {
            
            ActiveView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Active")
                }
            
            CompletedView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Completed")
                }
        }
    }
}
