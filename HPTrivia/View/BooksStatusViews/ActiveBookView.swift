import SwiftUI

struct ActiveBookView: View {
    @State var book: Book
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(book.image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 8)
            
            Image(systemName: "checkmark.circle.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(.green)
                .shadow(radius: 2)
                .padding(3)
        }
    }
}

#Preview {
    ActiveBookView(book: FetchBookQuestions().books[0])
}
