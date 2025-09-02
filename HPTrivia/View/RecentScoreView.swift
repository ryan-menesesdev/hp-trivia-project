//
//  RecentScoreView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 02/09/25.
//

import SwiftUI

struct RecentScoreView: View {
    @Binding var animateViewsIn: Bool
    
    var body: some View {
        VStack {
            if animateViewsIn {
                VStack(spacing: 8) {
                    Text("Recent Scores")
                        .font(.title2)
                    
                    Text("12")
                    
                    Text("12")
                    
                    Text("12")
                }
                .foregroundStyle(.white)
                .font(.title3)
                .padding(.horizontal)
                .background(.black.opacity(0.6))
                .clipShape(.rect(cornerRadius: 15))
                .transition(.opacity)
            }
        }
        .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
    }
}

#Preview {
    RecentScoreView(animateViewsIn: .constant(true))
}
