import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var filled = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTheme.body)
            .foregroundStyle(filled ? AppTheme.background : AppTheme.bodyText)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(filled ? AppTheme.tabSelected : AppTheme.titleHighlight))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
