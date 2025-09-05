import SwiftUI
import AVKit

struct ContentView: View {
    @State private var animateViewsIn = false
    @State private var audioPlayer: AVAudioPlayer!
    @State private var playGame = false
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedBackgroundView(geo: geo)
                
                VStack {
                    TitleView(animateViewsIn: $animateViewsIn)
                    
                    Spacer()
                     
                    RecentScoreView(animateViewsIn: $animateViewsIn)
                    
                    Spacer()
                    
                    ButtonBarView(animateViewsIn: $animateViewsIn, playGame: $playGame, geo: geo)
                    
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn.toggle()
//            playAudio()
        }
        .fullScreenCover(isPresented: $playGame) {
            QuestionView()
                .onAppear {
                    audioPlayer.setVolume(0, fadeDuration: 1.5)
                }
                .onDisappear {
                    audioPlayer.setVolume(1, fadeDuration: 3)
                }
        }
        
    }
    
    private func playAudio() {
        let audio = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: audio!))
        audioPlayer.play()
    }
}

#Preview {
    ContentView()
        .environment(GameViewModel())
}




