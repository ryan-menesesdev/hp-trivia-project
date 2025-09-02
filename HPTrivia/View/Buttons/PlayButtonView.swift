//
//  PlayButtonView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 02/09/25.
//

import SwiftUI

struct PlayButtonView: View {
    @Binding var animateViewsIn: Bool
    @State var scalePlayButton = false
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    // Play game
                } label: {
                    Text("Play")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 50)
                        .background(.brown.opacity(0.7))
                        .clipShape(.rect(cornerRadius: 7))
                        .shadow(color: .black, radius: 5)
                        .scaleEffect(scalePlayButton ? 1.2 : 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                scalePlayButton.toggle()
                            }
                        }
                }
                .transition(.offset(y: geo.size.height/3))
            }
        }
        .animation(.easeOut(duration: 1).delay(2), value: animateViewsIn)
    }
}

#Preview {
    GeometryReader { geo in
        PlayButtonView(animateViewsIn: .constant(true), geo: geo)
    }
}
