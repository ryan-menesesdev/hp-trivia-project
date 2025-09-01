import SwiftUI
import AVKit

struct ContentView: View {
    @State private var animateViewsIn = false
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 3)
                    .phaseAnimator([false, true]) { content, phase in
                        content
                            .offset(x: phase ? geo.size.width/1.1 : -geo.size.width/1.1)
                    } animation: { _ in
                            .linear(duration: 60)
                    }
                
                VStack() {
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                Text("HP")
                                    .font(.custom("PartyLetPlain", size:70))
                                Text("Trivia")
                                    .font(.custom("PartyLetPlain", size:60))
                            }
                            .padding(.top, 70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 1).delay(2), value: animateViewsIn)
                    
                    Spacer()
                    
                    Text("Recent Scores")
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            // Play game
                        } label: {
                            Image(systemName: "")
                        }
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    
                                } label: {
                                    Text("Play")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 50)
                                        .background(.brown.opacity(0.7))
                                        .clipShape(.rect(cornerRadius: 7))
                                        .shadow(color: .black, radius: 5)
                                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                                        .onAppear {
                                            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                                scalePlayButton.toggle()
                                            }
                                        }
                                }
                                .transition(.offset(y: geo.size.height/3))
                            }
                        }
                        .animation(.easeOut(duration: 1).delay(2), value: animateViewsIn)
                            
                        
                        Button {
                            
                        } label: {
                            
                        }
                    }
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
}
