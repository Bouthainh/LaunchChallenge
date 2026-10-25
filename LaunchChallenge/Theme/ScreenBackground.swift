import SwiftUI

struct ScreenBackground : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .background(AppTheme.background.ignoresSafeArea())
    }
}

extension View {
    func screenBackground() -> some View {
        modifier(ScreenBackground())
    }
}
