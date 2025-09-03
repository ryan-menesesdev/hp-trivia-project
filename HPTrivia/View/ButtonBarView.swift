//
//  ButtonBarView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 02/09/25.
//

import SwiftUI

struct ButtonBarView: View {
    @Binding var animateViewsIn: Bool
    @Binding var playGame: Bool
    
    let geo: GeometryProxy
    var body: some View {
        HStack {
            Spacer()
            
            InstructionButtonView(animateViewsIn: $animateViewsIn, geo: geo)
            
            Spacer()
            
            PlayButtonView(animateViewsIn: $animateViewsIn, playGame: $playGame, geo: geo)
            
            Spacer()
            
            SettingsButtonView(animateViewsIn: $animateViewsIn, geo: geo)
            
            Spacer()
        }
        .frame(width: geo.size.width)
    }
}

#Preview {
    GeometryReader { geo in
        ButtonBarView(animateViewsIn: .constant(true), playGame: .constant(false), geo: geo)
    }
}
