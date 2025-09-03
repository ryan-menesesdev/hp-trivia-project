//
//  SelectBooksView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 02/09/25.
//

import SwiftUI

struct SelectBooksView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(GameViewModel.self) private var game
    
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
                            if book.status == .active {
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
                            } else if book.status == .inactive {
                                ZStack {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 8)
                                }
                            } else {
                                ZStack {
                                    Image(book.image)
                                        .resizable()
                                        .scaledToFit()
                                        .shadow(radius: 8)
                                }
                            }
                        }
                    }
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
    SelectBooksView()
        .environment(GameViewModel())
}
