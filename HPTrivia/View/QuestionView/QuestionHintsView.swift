import SwiftUI

struct QuestionHintsView: View {
    @Binding var animateViewsIn: Bool
    @Binding var revealHint: Bool
    @Binding var revealBook: Bool
    @Binding var disableHint: Bool
    @Binding var disableRevealBook: Bool
    
    @Environment(GameViewModel.self) var game
    
    var geo: GeometryProxy
    let playFlip: () -> ()
    
    var body: some View {
        HStack {
            VStack {
                if animateViewsIn {
                    Button {
                        withAnimation(.easeOut(duration: animateViewsIn ? 0.75 : 0)) {
                            revealHint = true
                        }
                        playFlip()
                        game.correctAnswerScore -= 1
                        disableHint = true
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
                    .disabled(disableHint)
                }
            }
            .animation(.easeIn(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 1 : 0), value: animateViewsIn)
            
            Spacer()
            
            VStack {
                if animateViewsIn {
                    Button {
                        withAnimation(.easeOut(duration: animateViewsIn ? 0.75 : 0)) {
                            revealBook = true
                        }
                        playFlip()
                        game.correctAnswerScore -= 1
                        disableRevealBook = true
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
                    .disabled(disableRevealBook)
                }
            }
            .animation(.easeIn(duration: animateViewsIn ? 1.5 : 0).delay(animateViewsIn ? 1 : 0), value: animateViewsIn)
        }
        .padding()
    }
}

#Preview {
    GeometryReader { geo in
        QuestionHintsView(
            animateViewsIn: .constant(false),
            revealHint: .constant(false),
            revealBook: .constant(false),
            disableHint: .constant(false),
            disableRevealBook: .constant(false),
            geo: geo,
            playFlip: {}
        )
        .environment(GameViewModel())
    }
}
