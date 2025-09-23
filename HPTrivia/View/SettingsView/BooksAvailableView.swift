//
//  BooksAvailableView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 18/09/25.
//

import SwiftUI

struct BooksAvailableView: View {
    @Environment(GameViewModel.self) var game
    var store: StoreViewModel
    
    var body: some View {
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
                                do {
                                    try await store.purchase(product)
                                } catch {
                                    print("Unexpected error: \(error)")
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    BooksAvailableView(store: StoreViewModel())
        .environment(GameViewModel())
}
