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
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(game.fetcher.books) { book in
                            if book.status == .active || (book.status == .locked && store.purchased.contains(book.image)) {
                                    ActiveBookView(book: book)
                                    .task {
                                        game.fetcher.changeBookStatus(of: book.id, to: .active)
                                    }
                                    .onTapGesture {
                                        game.fetcher.changeBookStatus(of: book.id, to: .inactive)
                                    }
                            } else if book.status == .inactive {
                                InactiveBookView(book: book)
                                    .onTapGesture {
                                        game.fetcher.changeBookStatus(of: book.id, to: .active)
                                    }
                            } else {
                                LockedBookView(book: book)
                                    .onTapGesture {
                                        let product = store.products[book.id-4]
                                        Task {
                                            await store.purchase(product)
                                        }
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
                    game.fetcher.saveStatus()
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
            await store.loadProducts()
        }
    }
}

#Preview {
    SelectBooksView()
        .environment(GameViewModel())
}
