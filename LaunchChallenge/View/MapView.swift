import SwiftUI

struct MapView : View {
    var body: some View {
        
        Text("الخريطة")
            .foregroundStyle(.white)
            .screenBackground()
            .font(AppTheme.Title)
            
    }
}

#Preview {
    MapView()
}
