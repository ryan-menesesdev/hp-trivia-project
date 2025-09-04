import SwiftUI

struct SelectBooksView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GameViewModel.self) private var game
    @State private var showFakeAlert = false
    
    var activeBooks: Bool {
        for book in game.fetcher.books {
            if book.status == .active {
                return true
            }
        }
        
        return false
    }
    
    var body: some View {
        ZStack {
            
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
                
            VStack(alignment: .center) {
                Spacer()
                
                Text("Which books would you like to see questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                
                Spacer()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(game.fetcher.books) { book in
                            switch book.status {
                            case .active:
                                ActiveBookView(book: book)
                                    .onTapGesture {
                                        game.fetcher.changeBookStatus(of: book.id, to: .inactive)
                                    }
                            case .inactive:
                                InactiveBookView(book: book)
                                    .onTapGesture {
                                        game.fetcher.changeBookStatus(of: book.id, to: .active)
                                    }
                            default:
                                LockedBookView(book: book)
                                    .onTapGesture {
                                        showFakeAlert.toggle()
                                        
                                        game.fetcher.changeBookStatus(of: book.id, to: .active)
                                    }
                            }
                        }
                    }
                }
                .foregroundStyle(.black)
                
                if !activeBooks {
                    Text("You must select at least one book.")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }
                
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
                .disabled(!activeBooks)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
        }
        .interactiveDismissDisabled(!activeBooks)
        .alert("You have purchased the selected content! Enjoy 😄", isPresented: $showFakeAlert) {
            
        }
    }
}

#Preview {
    SelectBooksView()
        .environment(GameViewModel())
}
