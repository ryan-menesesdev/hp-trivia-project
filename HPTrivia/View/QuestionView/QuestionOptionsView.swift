import SwiftUI

struct QuestionOptionsView: View {
    @Binding var correctAnswerTapped: Bool
    @Binding var animateViewsIn: Bool
    @Binding var wrongAnswerTapped: [String]
    
    @Environment(GameViewModel.self) var game
    
    let playCorrectSound: () -> ()
    let playWrongSound: () -> ()
    
    var geo: GeometryProxy
    var namespace: Namespace.ID
    
    var body: some View {
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
                                game.correctAnswerScore -= 1
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
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    GeometryReader { geo in
        QuestionOptionsView(
            correctAnswerTapped: .constant(false),
            animateViewsIn: .constant(false),
            wrongAnswerTapped: .constant([]),
            playCorrectSound: {},
            playWrongSound: {},
            geo: geo,
            namespace: namespace
        )
    }
}
