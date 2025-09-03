import SwiftUI
import AVKit

struct ContentView: View {
    @State private var animateViewsIn = false
    @State private var audioPlayer: AVAudioPlayer!
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedBackgroundView(geo: geo)
                
                VStack {
                    TitleView(animateViewsIn: $animateViewsIn)
                    
                    Spacer()
                    
                    RecentScoreView(animateViewsIn: $animateViewsIn)
                    
                    Spacer()
                    
                    ButtonBarView(animateViewsIn: $animateViewsIn, geo: geo)
                    
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




