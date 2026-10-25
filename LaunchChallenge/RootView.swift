//  RootView.swift: holds shared components appear in all screens (Tab Bar, sound Button)
import SwiftUI


struct RootView : View {
    var body: some View {
        
        //setting tab bar for all screens
        TabView{
            MapView() //map tab: calling the map view
                .tabItem{
                    Label("Map" , image: "tab_map")
                }
            CanvasView() // canvas tab: calling the canvas view
                .tabItem{
                    Label("Canvas", image: "tab_canvas")
                    
                }
            BagView() //bag tab: calling the bag view
                .tabItem{
                    Label("Bag" , image: "tab_bag")
                }
                
        }.tint(AppTheme.tabSelected)
        

    }
}
#Preview {
    RootView()
}
