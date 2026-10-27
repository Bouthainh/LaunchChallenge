import AVFoundation
import Observation

@Observable
final class SoundManager {

    private(set) var isMusicOn: Bool
    private var player: AVAudioPlayer?

    init() {
        isMusicOn = UserDefaults.standard.object(forKey: "isMusicOn") as? Bool ?? true
    }

    private func setUpAudio() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        try? AVAudioSession.sharedInstance().setActive(true)

        guard let url = Bundle.main.url(forResource: "background_music", withExtension: "mp3") else {
            print("background_music.mp3 not found")
            return
        }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1
        player?.volume = 0.5
        player?.prepareToPlay()
    }

    func start() {
        guard isMusicOn else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            if self.player == nil { self.setUpAudio() }
            self.player?.play()
        }
    }
    func toggle() {
        isMusicOn.toggle()
        UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
        if isMusicOn {
            start()
        } else {
            player?.pause()
        }
    }
}
