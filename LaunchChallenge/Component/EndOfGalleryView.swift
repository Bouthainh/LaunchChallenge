import SwiftUI

struct EndOfGalleryView: View {
    let onBack: () -> Void
    let onStay: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("يا سلام على راعي الطيب..")
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.titleText)
                Text("تمّت رحلتك في هذا المعرض، واكتمل زادك من تراث المملكة!")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.bodyText)
                    .multilineTextAlignment(.center)
                HStack(spacing: 12) {
                    Button("البقاء هنا", action: onStay)
                        .buttonStyle(PrimaryButtonStyle(filled: false))
                    Button("العودة للخريطة", action: onBack)
                        .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 24).fill(AppTheme.background))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppTheme.tabSelected, lineWidth: 1))
            .padding(.horizontal, 32)
        }
    }
}
