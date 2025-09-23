import SwiftUI

struct InactiveBookView: View {
    @State var book: Book
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(book.image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 8)
                .overlay {
                    Rectangle().opacity(0.33)
                }
            
            Image(systemName: "checkmark.circle")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(.green.opacity(0.5))
                .shadow(radius: 2)
                .padding(3)
        }
    }
}

#Preview {
    InactiveBookView(book: FetchBookQuestions().books[0])
}
