import SwiftUI

struct FinaleView: View {
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("حي عينك يا الكفو")
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.titleText)
                Text("جمعت الأختام، وطويت دروب المناطق الخمس، وحصدت علم وأثر يبقى معك من حكايا الأوّلين وزخارفهم")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.bodyText)
                    .multilineTextAlignment(.center)
                Text("عساها رحلةٍ ما تنسى، وتراثٍ يبقى في قلبك ما دام الزمن يدور 🌴")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.bodyText)
                    .multilineTextAlignment(.center)
                Button("إغلاق", action: onClose)
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, 40)
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 24).fill(AppTheme.background))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppTheme.tabSelected, lineWidth: 1))
            .padding(.horizontal, 32)
        }
    }
}
