import Foundation
import AVFoundation

class AudioPlayerManager {
    
    static let shared = AudioPlayerManager()
    var playerBackground: AVAudioPlayer?
    var player: AVAudioPlayer?
    var musicOff = false
    
    private init() {}
    
    func canPlay() -> Bool {
        return !musicOff
    }
    
    func playSoundBack() {
        self.playBack(forResource: "soundBack", withExtension: "wav", numberOfLoops: -1)
    }
    
    func playDrive() {
        self.playBack(forResource: "drive", withExtension: "wav", numberOfLoops: -1)
    }
    
    func playClick() {
        self.play(forResource: "click", withExtension: "wav")
    }
    
    func playCrash() {
        self.play(forResource: "crash", withExtension: "wav")
    }
    
    private func play(forResource: String, withExtension: String, numberOfLoops: Int = 0) {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: url)
            if let player = self.player {
                player.numberOfLoops = numberOfLoops
                player.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func playBack(forResource: String, withExtension: String, numberOfLoops: Int = 0) {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.playerBackground = try AVAudioPlayer(contentsOf: url)
            if let player = self.playerBackground {
                player.numberOfLoops = numberOfLoops
                player.play()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pause() {
        if self.player?.isPlaying ?? false {
            self.player?.pause()
        }
    }
    
    func continuePlay() {
        self.player?.play()
    }
    
    func stop() {
        self.player?.stop()
    }
    
    func stopBackground() {
        self.playerBackground?.stop()
    }
}
