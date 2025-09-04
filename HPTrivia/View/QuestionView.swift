import SwiftUI
import AVKit

struct QuestionView: View {
    @Environment(GameViewModel.self) private var game
    @Environment(\.dismiss) private var dismiss
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    
    @State private var animateViewsIn = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width*3, height: geo.size.height*1.05)
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.7))
                    }
                
                VStack {
                    HStack {
                        Button {
                            game.endGame()
                            dismiss()
                        } label: {
                            Text("End Game")
                                .font(.title2)
                                .padding(10)
                                .background(.red.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 16))
                        }
                        
                        Spacer()
                        
                        Text("Score: \(game.score)")
                            .foregroundStyle(.white)
                            .font(.title2)
                    }
                    .padding()
                    .padding(.top, 30)
                     
                    VStack {
                        if animateViewsIn {
                            Text(game.currentQuestion.question)
                                .minimumScaleFactor(0.2)
                                .font(.custom("PartyLetPlain", size: 50))
                                .multilineTextAlignment(.center)
                                .padding()
                                .transition(.scale)
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: animateViewsIn)
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "questionmark.app.fill")
                                .foregroundStyle(.blue)
                                .font(.largeTitle)
                                .imageScale(.large)
                                
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "questionmark.app.fill")
                                .foregroundStyle(.blue)
                                .font(.largeTitle)
                                .imageScale(.large)
                                
                        }
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                    
            }
            .foregroundStyle(.white)
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            game.startGame()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateViewsIn.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                playMusic()
            }
        }
    }
    
    private func playMusic() {
        let songs = ["let-the-mystery-unfold", "spellcraft", "hiding-place-in-the-forest", "deep-in-the-dell"]
        
        let song = songs.randomElement()!
        
        let sound = Bundle.main.path(forResource: song, ofType: "mp3")
        musicPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        musicPlayer.numberOfLoops = -1
        musicPlayer.volume = 0.1
        musicPlayer.play()
    }
    
    private func playFlip() {
        let sound = Bundle.main.path(forResource: "page-flip", ofType: "mp3")
        
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.1
        sfxPlayer.play()
    }
    
    private func playCorrectSound() {
        let sound = Bundle.main.path(forResource: "magic-wand", ofType: "mp3")
        
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.1
        sfxPlayer.play()
    }
    
    private func playWrongSound() {
        let sound = Bundle.main.path(forResource: "negative-beeps", ofType: "mp3")
        
        sfxPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        sfxPlayer.volume = 0.1
        sfxPlayer.play()
    }
}

#Preview {
    QuestionView()
        .environment(GameViewModel())
}
