import SwiftUI

struct CanvasView : View {
    
    var body: some View {
        
        Text("Canvas")
            .foregroundStyle(.white)
            .screenBackground()
            .font(AppTheme.Title)

        
    }
}
#Preview {
    CanvasView()
}
