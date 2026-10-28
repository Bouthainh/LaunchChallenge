//  RootView.swift: holds shared components appear in all screens (Tab Bar, sound Button)
import SwiftUI

struct RootView: View {

    @State private var sound = SoundManager()
    @State private var store = ProgressStore()

    var body: some View {

        //setting tab bar for all screens
        TabView {
            MapView() //map tab: calling the map view
                .tabItem {
                    Label("الخريطـة", image: "tab_map")
                }
            CanvasView() // canvas tab: calling the canvas view
                .tabItem {
                    Label("اللوحـة", image: "tab_canvas")
                }
            BagView() //bag tab: calling the bag view
                .tabItem {
                    Label("الحقيبـة", image: "tab_bag")
                }
        }
        .tint(AppTheme.tabSelected)
        .environment(\.layoutDirection, .rightToLeft) //temp for test "layout", will be removed after localization
        
        .environment(sound)
        .environment(store) 
        .onAppear { sound.start() }
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
