//
//  LockedBookView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 03/09/25.
//

import SwiftUI

struct LockedBookView: View {
    @State var book: Book
    
    var body: some View {
        ZStack {
            Image(book.image)
                .resizable()
                .scaledToFit()
                .shadow(radius: 8)
                .overlay {
                    Rectangle().opacity(0.77)
                }
            
            Image(systemName: "lock.fill")
                .font(.largeTitle)
                .imageScale(.large)
                .shadow(color: .white, radius: 3)
                .padding(3)
        }
    }
}

#Preview {
    LockedBookView(book: FetchBookQuestions().books[0])
}
