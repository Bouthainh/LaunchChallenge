import SwiftUI

struct SoundButton: View {
    @Environment(SoundManager.self) private var sound

    var body: some View {
        Button {
            sound.toggle()
        } label: {
            Image(systemName: sound.isMusicOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppTheme.tabSelected)
                .frame(width: 50, height: 50)
                .background(Capsule().fill(.ultraThinMaterial))
                .environment(\.colorScheme, .dark)
        }
    }
}
