//
//  TitleView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 02/09/25.
//

import SwiftUI

struct TitleView: View {
    @Binding var animateViewsIn: Bool
    
    var body: some View {
        VStack {
            if animateViewsIn {
                VStack {
                    Image(systemName: "bolt.fill")
                        .font(.largeTitle)
                    Text("HP")
                        .font(.custom("PartyLetPlain", size:70))
                    Text("Trivia")
                        .font(.custom("PartyLetPlain", size:60))
                }
                .padding(.top, 70)
                .transition(.move(edge: .top))
            }
        }
        .animation(.easeOut(duration: 1).delay(2), value: animateViewsIn)
    }
}

#Preview {
    TitleView(animateViewsIn: .constant(true))
}
