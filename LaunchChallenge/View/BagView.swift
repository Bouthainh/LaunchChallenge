import SwiftUI

struct BagView : View {
    
    var body: some View {
        
        Text("Bag")
            .foregroundStyle(.white)
            .screenBackground()
            .font(AppTheme.Title)

    }
}
#Preview {
  BagView()
}
