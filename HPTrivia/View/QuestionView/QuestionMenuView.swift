import SwiftUI

struct QuestionMenuView: View {
    @Environment(GameViewModel.self) private var game
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
    }
}

#Preview {
    QuestionMenuView()
        .environment(GameViewModel())
}
