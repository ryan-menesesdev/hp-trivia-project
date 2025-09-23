import SwiftUI

struct QuestionAnsweredEventsView: View {
    @Binding var correctAnswerTapped: Bool
    @Binding var movePointsToScore: Bool
    @Binding var animateViewsIn: Bool
    @Binding var revealHint: Bool
    @Binding var revealBook: Bool
    @Binding var wrongAnswerTapped: [String]
    
    @Environment(GameViewModel.self) var game
    
    var geo: GeometryProxy
    var namespace: Namespace.ID
    
    var body: some View {
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
                        Text("Next Level")
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

#Preview {
    @Previewable @Namespace var namespace
    
    GeometryReader { geo in
        QuestionAnsweredEventsView(
            correctAnswerTapped: .constant(false),
            movePointsToScore: .constant(false),
            animateViewsIn: .constant(false),
            revealHint: .constant(false),
            revealBook: .constant(false),
            wrongAnswerTapped: .constant([]),
            geo: geo,
            namespace: namespace
        )
        .environment(GameViewModel())
    }
}
