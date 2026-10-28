import SwiftUI

struct LockedStationView: View {
    let onStart: () -> Void
    @State private var showPrompt = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(AppTheme.tabSelected)
                Text("جاهز للمحطـة التاليـة...")
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.bodyText)
                Button("حل اللغـز", action: onStart)
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.horizontal, 70)
            }

            if showPrompt { prompt }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .screenBackground()
        .task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation { showPrompt = true }
        }
    }

    private var prompt: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 16) {
                Text("هل أنت مستعـد للغـز؟")
                    .font(AppTheme.Title)
                    .foregroundStyle(AppTheme.titleText)
                Text("لفتح المحطة التاليـة، عليـك حل لغز المعـرض")
                    .font(AppTheme.body)
                    .foregroundStyle(AppTheme.bodyText)
                    .multilineTextAlignment(.center)
                HStack(spacing: 12) {
                    Button("لا") { withAnimation { showPrompt = false } }
                        .buttonStyle(PrimaryButtonStyle(filled: false))
                    Button("نعم") { showPrompt = false; onStart() }
                        .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 24).fill(AppTheme.background))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(AppTheme.tabSelected, lineWidth: 1))
            .padding(.horizontal, 32)
        }
        .transition(.opacity)
    }
}
