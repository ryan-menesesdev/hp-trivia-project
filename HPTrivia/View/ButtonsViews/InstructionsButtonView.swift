//
//  InstructionButtonView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 02/09/25.
//

import SwiftUI

struct InstructionButtonView: View {
    @Binding var animateViewsIn: Bool
    @State var instructionsTapped = false
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    instructionsTapped.toggle()
                } label: {
                    Image(systemName: "info.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 6)
                }
                .transition(.offset(x: -geo.size.width/3))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
        .sheet(isPresented: $instructionsTapped) {
            InstructionView()
        }
    }
}

#Preview {
    GeometryReader { geo in
        InstructionButtonView(animateViewsIn: .constant(true), geo: geo)
    }
}
