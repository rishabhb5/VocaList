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
            
            DebugView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Debug")
                }
        }
    }
}
