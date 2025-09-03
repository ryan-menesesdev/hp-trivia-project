import SwiftUI

@main
struct HPTriviaApp: App {
    private var game = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(game)
        }
    }
}
