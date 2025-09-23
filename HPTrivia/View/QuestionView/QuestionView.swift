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
    @State private var disableHint = false
    @State private var disableRevealBook = false
    @State private var correctAnswerTapped = false
    @State private var wrongAnswerTapped: [String] = []
    @State private var movePointsToScore = false
    @State private var viewError: ViewError?
    
    let audioManager = AudioManager.shared
    
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
                    QuestionMenuView()
                    
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
                        
                        QuestionHintsView(
                            animateViewsIn: $animateViewsIn,
                            revealHint: $revealHint,
                            revealBook: $revealBook,
                            disableHint: $disableHint,
                            disableRevealBook: $disableRevealBook,
                            geo: geo,
                            playFlip: { handleAction { try audioManager.playFlip() } }
                        )
                        Spacer()
                        
                        QuestionOptionsView(
                            correctAnswerTapped: $correctAnswerTapped,
                            animateViewsIn: $animateViewsIn,
                            wrongAnswerTapped: $wrongAnswerTapped,
                            playCorrectSound: { handleAction { try audioManager.playCorrectSound() } },
                            playWrongSound: { handleAction { try audioManager.playWrongSound() } },
                            geo: geo,
                            namespace: namespace
                        )
                        Spacer()
                    }
                    .disabled(correctAnswerTapped)
                    .opacity(correctAnswerTapped ? 0.1 : 1)
 
                }
                .frame(width: geo.size.width, height: geo.size.height)
                
                VStack {
                    QuestionAnsweredEventsView(
                        correctAnswerTapped: $correctAnswerTapped,
                        movePointsToScore: $movePointsToScore,
                        animateViewsIn: $animateViewsIn,
                        revealHint: $revealHint,
                        revealBook: $revealBook,
                        wrongAnswerTapped: $wrongAnswerTapped,
                        geo: geo,
                        namespace: namespace
                    )
                }
                    
            }
            .foregroundStyle(.white)
            .frame(width: geo.size.width, height: geo.size.height)
            .alert("Error", isPresented: .constant(viewError != nil), presenting: viewError) { error in
                Button("Ok") { viewError = nil }
            } message: { error in
                Text(error.localizedDescription)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            handleAction {
                game.startGame()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateViewsIn.toggle()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    handleAction {
                        try audioManager.playMusic()
                    }
            }
        }
    }
    
    private func handleAction(_ action: () throws -> Void) {
        do {
            try action()
        } catch let error as ViewError {
            viewError = error
        } catch {
            viewError = .other(error)
        }
    }
    
}

#Preview {
    QuestionView()
        .environment(GameViewModel())
}
