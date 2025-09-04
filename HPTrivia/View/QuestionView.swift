import SwiftUI
import AVKit

struct QuestionView: View {
    @Environment(GameViewModel.self) private var game
    @Environment(\.dismiss) private var dismiss
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    
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
                    
                    HStack {
                        // Hints
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    withAnimation(.easeOut(duration: 0.75)) {
                                        revealHint.toggle()
                                    }
                                    playFlip()
                                    game.correctAnswerScore -= 1
                                } label: {
                                    Image(systemName: "questionmark.app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .foregroundStyle(.cyan)
                                        .padding()
                                        .phaseAnimator([false, true]) { content, phase in
                                            content
                                                .rotationEffect(.degrees(phase ? -13 : -17))
                                        } animation: { _ in
                                                .easeInOut(duration: 0.5)
                                        }
                                        .rotation3DEffect(.degrees(revealHint ? 1440 : 0), axis: (x: 0, y: 1, z: 0))
                                        .scaleEffect(revealHint ? 5 : 1)
                                        .offset(x: revealHint ? geo.size.width/2 : 0)
                                        .opacity(revealHint ? 0 : 1)
                                        .overlay {
                                            Text("\(game.currentQuestion.hint)")
                                                .padding(.leading, 20)
                                                .minimumScaleFactor(0.5)
                                                .multilineTextAlignment(.center)
                                                .opacity(revealHint ? 1 : 0)
                                                .scaleEffect(revealHint ? 1.33 : 1)
                                        }
                                }
                                .transition(.offset(x: -geo.size.width/2))
                            }
                        }
                        .animation(.easeIn(duration: 1.5).delay(1), value: animateViewsIn)

                        Spacer()
                        
                        VStack {
                            if animateViewsIn {
                                Button {
                                    withAnimation(.easeOut(duration: 0.75)) {
                                        revealBook.toggle()
                                    }
                                    playFlip()
                                    game.correctAnswerScore -= 1
                                } label: {
                                    Image(systemName: "app.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .foregroundStyle(.cyan)
                                        .overlay(content: {
                                            Image(systemName: "book.closed")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50)
                                                .foregroundStyle(.black)
                                        })
                                        .padding()
                                        .phaseAnimator([false, true]) { content, phase in
                                            content
                                                .rotationEffect(.degrees(phase ? 13 : 17))
                                        } animation: { _ in
                                                .easeInOut(duration: 0.5)
                                        }
                                        .rotation3DEffect(.degrees(revealBook ? -1440 : 0), axis: (x: 0, y: 1, z: 0))
                                        .scaleEffect(revealBook ? 5 : 1)
                                        .offset(x: revealBook ? -geo.size.width/2 : 0)
                                        .opacity(revealBook ? 0 : 1)
                                        .overlay {
                                            Image("hp\(game.currentQuestion.book)")
                                                .resizable()
                                                .scaledToFit()
                                                .padding(.trailing, 20)
                                                .opacity(revealBook ? 1 : 0)
                                                .scaleEffect(revealBook ? 1.33 : 1)
                                            
                                        }
                                }
                                .transition(.offset(x: geo.size.width/2))
                            }
                        }
                        .animation(.easeIn(duration: 1.5).delay(1), value: animateViewsIn)
                    }
                    .padding()
                    
                    Spacer()
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
//                playMusic()
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
