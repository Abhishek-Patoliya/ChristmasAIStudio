import SwiftUI

public struct MainTabView: View {
    @ObservedObject var appState = AppState.shared
    
    public init() {
        // Customize UITabBar appearance for festive theme
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.08, green: 0.10, blue: 0.12, alpha: 0.98)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.90, green: 0.75, blue: 0.38, alpha: 1.0)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(red: 0.90, green: 0.75, blue: 0.38, alpha: 1.0)
        ]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(white: 0.6, alpha: 1.0)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(white: 0.6, alpha: 1.0)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    public var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "sparkles")
                }
                .tag(0)
            
            StyleSelectionView()
                .tabItem {
                    Label("Styles", systemImage: "wand.and.stars")
                }
                .tag(1)
            
            SavedCreationsView()
                .tabItem {
                    Label("Gallery", systemImage: "photo.stack.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(Theme.gold)
    }
}
