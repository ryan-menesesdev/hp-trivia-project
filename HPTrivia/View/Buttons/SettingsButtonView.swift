//
//  SettingsButtonView.swift
//  HPTrivia
//
//  Created by Ryan Davi Oliveira de Meneses on 02/09/25.
//

import SwiftUI

struct SettingsButtonView: View {
    @Binding var animateViewsIn: Bool
    @State var settingsTapped = false
    
    let geo: GeometryProxy
    
    var body: some View {
        VStack {
            if animateViewsIn {
                Button {
                    settingsTapped.toggle()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .shadow(radius: 6)
                }
                .transition(.offset(x: geo.size.width/3))
            }
        }
        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
        .sheet(isPresented: $settingsTapped) {
            SettingsView()
        }
    }
}

#Preview {
    GeometryReader { geo in
        SettingsButtonView(animateViewsIn: .constant(true), geo: geo)
    }
}
