import Foundation
import AVKit

class AudioManager {
    static let shared = AudioManager()
    
    private var musicPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?
    
    private init() { }
    
    func playMusic() throws {
        let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
    
        guard let song = songs.randomElement(),
        let sound = Bundle.main.path(forResource: song, ofType: "mp3") else {
            throw ViewError.fetch(.badPathError)
        }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.volume = 0.1
            musicPlayer?.play()
        } catch {
            throw ViewError.av(.failedToPlayMusic)
        }
    }
    
    func playHomeScreenMusic() throws {
        guard let audio = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3") else {
            throw ViewError.fetch(.badPathError)
        }
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(filePath: audio))
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.volume = 0.1
            musicPlayer?.play()
        } catch {
            throw ViewError.av(.failedToPlayMusic)
        }
    }
    
    private func playSound(named fileName: String) throws {
        guard let sound = Bundle.main.path(forResource: fileName, ofType: "mp3") else {
            throw ViewError.fetch(.badPathError)
        }

        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: URL(filePath: sound))
            sfxPlayer?.volume = 0.1
            sfxPlayer?.play()
        } catch {
            throw ViewError.av(.failedToPlaySound)
        }
    }
    
    func playFlip() throws {
        try playSound(named: "page-flip")
    }
    
    func playCorrectSound() throws {
        try playSound(named: "magic-wand")
    }
    
    func playWrongSound() throws {
        try playSound(named: "negative-beeps")
    }
    
    func setMusicVolume(_ volume: Float, fadeDuration: Double) {
        guard let musicPlayer = musicPlayer else { return }
        
        if fadeDuration <= 0 {
            musicPlayer.volume = volume
            return
        }

        let startVolume = musicPlayer.volume
        let volumeDelta = volume - startVolume
        let fadeSteps = 10
        let stepDuration = fadeDuration / Double(fadeSteps)
        
        for i in 0..<fadeSteps {
            DispatchQueue.main.asyncAfter(deadline: .now() + (stepDuration * Double(i))) {
                let progress = Float(i) / Float(fadeSteps)
                self.musicPlayer?.volume = startVolume + (volumeDelta * progress)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
            self.musicPlayer?.volume = volume
        }
    }
        
    func pauseMusic() {
        musicPlayer?.pause()
    }
    
    func resumeMusic() {
        musicPlayer?.play()
    }
}
