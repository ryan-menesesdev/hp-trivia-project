import SwiftUI

struct InstructionView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
                
            
            VStack(alignment: .center) {
                Image(.appiconwithradius)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top, 24)
                
                Spacer()
                
                Text("How To Play")
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
                
                ScrollView {
                    VStack(alignment:.leading, spacing: 30) {
                        Text("Welcome to HP Trivia! In this game you will be asked random questions from the HP books and you must guess the right answer or you will lose points!😱")
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                        
                        Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using these also removes 1 point each.")
                        
                        Text("When you select the correct answer, you will be awarded all the points left for that question and they will be added to your total score.")
                    }
                    .font(.title3)
                    
                    Text("Good Luck!")
                        .font(.title)
                }
                .foregroundStyle(.black)
                
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .foregroundStyle(.white)
                        .font(.title)
                }
                .padding(8)
                .background(.brown.opacity(0.7))
                .clipShape(.rect(cornerRadius: 8))
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    InstructionView()
}
