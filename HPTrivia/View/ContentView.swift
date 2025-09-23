import SwiftUI
import AVKit

struct ContentView: View {
    @State private var animateViewsIn = false
    @State private var playGame = false
    @State private var viewError: ViewError?

    let audioManager = AudioManager.shared

    var body: some View {
        GeometryReader { geo in
            ZStack {
                AnimatedBackgroundView(geo: geo)

                VStack {
                    TitleView(animateViewsIn: $animateViewsIn)

                    Spacer()

                    RecentScoreView(animateViewsIn: $animateViewsIn)

                    Spacer()

                    ButtonBarView(animateViewsIn: $animateViewsIn, playGame: $playGame, geo: geo)

                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn.toggle()
            handleAction {
                try audioManager.playHomeScreenMusic()
            }
        }
        .fullScreenCover(isPresented: $playGame) {
            QuestionView()
                .onAppear {
                    audioManager.setMusicVolume(0, fadeDuration: 1.5)
                }
                .onDisappear {
                    audioManager.setMusicVolume(0.1, fadeDuration: 3)
                    handleAction {
                        try audioManager.playHomeScreenMusic()
                    }
                }
        }
        .alert("Error", isPresented: .constant(viewError != nil), presenting: viewError) { error in
            Button("Ok") { viewError = nil }
        } message: { error in
            Text(error.localizedDescription)
        }
    }

    private func handleAction(_ action: () throws -> Void) {
        do {
            try action()
        } catch let error as ViewError {
            viewError = error
        } catch {
            viewError = .other(error)
        }
    }
}

#Preview {
    ContentView()
        .environment(GameViewModel())
}
