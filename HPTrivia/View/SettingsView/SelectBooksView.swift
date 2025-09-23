import SwiftUI

struct SelectBooksView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GameViewModel.self) private var game
    
    private var store = StoreViewModel()
    
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
                    BooksAvailableView(store: store)
                }
                .foregroundStyle(.black)
                
                if !activeBooks {
                    Text("You must select at least one book.")
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                }
                
                Button {
                    do {
                        try game.fetcher.saveStatus()
                    } catch {
                        print("Unexpected error: \(error)")
                    }
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
        .interactiveDismissDisabled()
        .task {
            do {
                try await store.loadProducts()
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
}

#Preview {
    SelectBooksView()
        .environment(GameViewModel())
}
