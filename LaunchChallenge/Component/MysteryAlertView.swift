import SwiftUI

struct MysteryAlertView: View {
    var onYes: () -> Void
    var onNo: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack(spacing: 16) {
                Text("هل أنت مستعد للغز؟")
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.bodyText)

                Text("لفتح المحطة التالية، عليك حل لغز المعرض")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.bodyText.opacity(0.8))
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button(action: onNo) {
                        Text("لا")
                            .font(AppTheme.body)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.gray.opacity(0.4))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                    Button(action: onYes) {
                        Text("نعم")
                            .font(AppTheme.body)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(AppTheme.tabSelected)
                            .foregroundStyle(AppTheme.background)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(20)
            .background(Color(white: 0.12))
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(AppTheme.tabSelected, lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 32)
        }
    }
}
