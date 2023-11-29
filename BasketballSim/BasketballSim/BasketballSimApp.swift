import SwiftUI

@main
struct BasketballSimApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(model: GameModel())
        }
    }
}
