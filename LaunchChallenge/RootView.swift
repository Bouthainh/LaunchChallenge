//  RootView.swift: holds shared components appear in all screens (Tab Bar, sound Button)
import SwiftUI

struct RootView: View {

    @State private var sound = SoundManager()
    
    @State private var progress = ProgressStore()

    var body: some View {

        //setting tab bar for all screens
        TabView {
            MapView() //map tab: calling the map view
                .tabItem {
                    Label("Map", image: "tab_map")
                }
            CanvasView() // canvas tab: calling the canvas view
                .tabItem {
                    Label("Canvas", image: "tab_canvas")
                }
            BagView() //bag tab: calling the bag view
                .tabItem {
                    Label("Bag", image: "tab_bag")
                }
        }
        .tint(AppTheme.tabSelected)
        .environment(\.layoutDirection, .rightToLeft)
        //temp for test "layout", will be removed after localization
        
        .environment(sound)
        .environment(progress)
        .onAppear { sound.start()
            #if DEBUG
            progress.seedDemoIfEmpty()           //بياانات تجريبيه
                       #endif
            
            
            
            
        }
        .overlay(alignment: .topLeading) {
            SoundButton()
                .padding(.leading, 20)
                .padding(.top, 4)
                .environment(sound)
        }
    }
}

#Preview {
    RootView()
}
