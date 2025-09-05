import SwiftUI
import AVKit

struct QuestionView: View {
    @Environment(GameViewModel.self) private var game
    @Environment(\.dismiss) private var dismiss
    @Namespace private var namespace
    
    @State private var musicPlayer: AVAudioPlayer!
    @State private var sfxPlayer: AVAudioPlayer!
    @State private var animateViewsIn = false
    @State private var revealHint = false
    @State private var revealBook = false
    @State private var correctAnswerTapped = false
    @State private var wrongAnswerTapped: [String] = []
    @State private var movePointsToScore = false
    
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
                        .animation(.easeInOut(duration: animateViewsIn ? 0.5 : 0), value: animateViewsIn)
                        
                        HStack {
                            VStack {
                                if animateViewsIn {
                                    Button {
                                        withAnimation(.easeOut(duration: animateViewsIn ? 0.75 : 0)) {
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
                                                    .easeInOut(duration: animateViewsIn ? 0.5 : 0)
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
                            .animation(.easeIn(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 1 : 0), value: animateViewsIn)
                            
                            Spacer()
                            
                            VStack {
                                if animateViewsIn {
                                    Button {
                                        withAnimation(.easeOut(duration: animateViewsIn ? 0.75 : 0)) {
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
                                                    .easeInOut(duration: animateViewsIn ? 0.5 : 0)
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
                            .animation(.easeIn(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 1 : 0), value: animateViewsIn)
                        }
                        .padding()
                        
                        
                        Spacer()
                        
                        LazyVGrid(columns: [GridItem(), GridItem()]) {
                            ForEach(game.answers, id: \.self) { answer in
                                if answer == game.currentQuestion.answer {
                                    VStack {
                                        if animateViewsIn {
                                            if !correctAnswerTapped {
                                                Button {
                                                    withAnimation(.easeOut(duration: 1)) {
                                                        correctAnswerTapped.toggle()
                                                    }
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.8) {
                                                        game.correct()
                                                    }
                                                    
                                                    playCorrectSound()
                                                    
                                                    // game.newQuestion()
                                                } label: {
                                                    Text(answer)
                                                        .minimumScaleFactor(0.5)
                                                        .multilineTextAlignment(.center)
                                                        .padding()
                                                        .frame(width: geo.size.width/2.15, height: 80)
                                                        .background(.green.opacity(0.6))
                                                        .clipShape(.rect(cornerRadius: 16))
                                                        .matchedGeometryEffect(id: 1, in: namespace)
                                                }
                                                .transition(.asymmetric(insertion: .scale, removal: .scale(scale: 15).combined(with: .opacity)))
                                            }
                                        }
                                    }
                                    .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                                } else {
                                    VStack {
                                        if animateViewsIn {
                                            Button {
                                                game.score -= 1
                                                withAnimation(.easeOut(duration: animateViewsIn ? 1 : 0)) {
                                                    wrongAnswerTapped.append(answer)
                                                }
                                                playWrongSound()
                                            } label: {
                                                Text(answer)
                                                    .minimumScaleFactor(0.5)
                                                    .multilineTextAlignment(.center)
                                                    .padding()
                                                    .frame(width: geo.size.width/2.15, height: 80)
                                                    .background(wrongAnswerTapped.contains(answer) ? .red.opacity(0.6) : .green.opacity(0.6))
                                                    .clipShape(.rect(cornerRadius: 16))
                                                    .scaleEffect(wrongAnswerTapped.contains(answer) ? 0.8 : 1)
                                            }
                                            .transition(.scale)
                                            .sensoryFeedback(.error, trigger: wrongAnswerTapped)
                                            .disabled(wrongAnswerTapped.contains(answer) ? true : false)
                                        }
                                    }
                                    .animation(.easeOut(duration: animateViewsIn ? 1 : 0).delay(animateViewsIn ? 1.5 : 0), value: animateViewsIn)
                                }
                            }
                        }
                        Spacer()
                    }
                    .disabled(correctAnswerTapped)
                    .opacity(correctAnswerTapped ? 0.1 : 1)
 
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                VStack {
                    Spacer()
                    
                    VStack {
                        if correctAnswerTapped {
                            Text("\(game.correctAnswerScore)")
                                .font(.largeTitle)
                                .padding(.top, 50)
                                .transition(.offset(y: -geo.size.height/4))
                                .offset(x: movePointsToScore ? geo.size.width/3 : 0, y: movePointsToScore ? -geo.size.height/13 : 0)
                                .opacity(movePointsToScore ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: correctAnswerTapped ? 1 : 0).delay(correctAnswerTapped ? 3 : 0)) {
                                        movePointsToScore.toggle()
                                    }
                                }
                        }
                    }
                    .animation(.easeInOut(duration: correctAnswerTapped ? 1 : 0).delay(correctAnswerTapped ? 2 : 0), value: correctAnswerTapped)
                    
                    Spacer()
                    
                    VStack {
                        if correctAnswerTapped {
                            Text("Brilliant")
                                .font(.custom("PartyLetPlain", size: 100))
                                .transition(.scale.combined(with: .offset(y: -geo.size.height/2)))
                        }
                    }
                    .animation(.easeInOut(duration: correctAnswerTapped ? 1 : 0).delay(correctAnswerTapped ? 1 : 0), value: correctAnswerTapped)
                    
                    Spacer()
                    
                    if correctAnswerTapped {
                        Text(game.currentQuestion.answer)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: geo.size.width/2.15, height: 80)
                            .background(.green)
                            .clipShape(.rect(cornerRadius: 16))
                            .scaleEffect(2)
                            .matchedGeometryEffect(id: 1, in: namespace)
                    }
                    
                    Spacer()
                    Spacer()
                    
                    VStack {
                        if correctAnswerTapped {
                            Button {
                                animateViewsIn = false
                                revealHint = false
                                revealBook = false
                                correctAnswerTapped = false
                                wrongAnswerTapped = []
                                movePointsToScore = false
                                
                                game.newQuestion()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    animateViewsIn = true
                                }
                            } label: {
                                Text("Next Level ->")
                                    .font(.largeTitle)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue.opacity(0.5))
                            .transition(.offset(y: geo.size.height/3))
                        }
                    }
                    .animation(.easeInOut(duration: correctAnswerTapped ? 2.7 : 0).delay(correctAnswerTapped ? 2.7 : 0), value: correctAnswerTapped)
                    
                    Spacer()
                    Spacer()
                }
                    
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
