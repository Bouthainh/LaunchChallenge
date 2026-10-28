import SwiftUI

struct LockedStationView: View {

    var body: some View {
        VStack(spacing: 24) {
            Text("جاهز للمحطة التالية...")
                .font(AppTheme.Title)
                .foregroundStyle(AppTheme.bodyText)
                .multilineTextAlignment(.center)

            Image(systemName: "lock.fill") // later: Image("lock") from your assets
                .font(.system(size: 70))
                .foregroundStyle(AppTheme.tabSelected)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .screenBackground()
    }
}
