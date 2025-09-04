import SwiftUI

struct RecentScoreView: View {
    @Environment(GameViewModel.self) private var game
    @Binding var animateViewsIn: Bool
    
    var body: some View {
        VStack {
            if animateViewsIn {
                VStack(spacing: 8) {
                    Text("Recent Scores")
                        .font(.title2)
                    
                    Text("\(game.recentScores[0])")
                    Text("\(game.recentScores[1])")
                    Text("\(game.recentScores[2])")
                }
                .foregroundStyle(.white)
                .font(.title3)
                .padding(.horizontal)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 15))
                .transition(.opacity)
            }
        }
        .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
    }
}

#Preview {
    RecentScoreView(animateViewsIn: .constant(true))
        .environment(GameViewModel())
}
