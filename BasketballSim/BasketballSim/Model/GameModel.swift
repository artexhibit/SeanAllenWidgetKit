import Foundation
import ActivityKit

final class GameModel: ObservableObject, GameSimulatorDelegate {

    @Published var gameState = GameState(homeScore: 0,
                                          awayScore: 0,
                                          scoringTeamName: "",
                                          lastAction: "")
    
    var liveActivity: Activity<GameAttributes>? = nil
    let simulator = GameSimulator()

    init() {
        simulator.delegate = self
    }
    
    func startLiveActivity() {
        let attributes = GameAttributes(homeTeam: "warriors", awayTeam: "bulls")
        let currentGameState = GameAttributes.ContentState(gameState: gameState)
        
        do {
            liveActivity = try Activity.request(attributes: attributes, contentState: currentGameState)
        } catch {
            print(error)
        }
    }

    func didUpdate(gameState: GameState) {
        self.gameState = gameState
        
        Task {
            await liveActivity?.update(using: .init(gameState: gameState))
        }
    }

    func didCompleteGame() {
        Task {
            await liveActivity?.end(using: .init(gameState: simulator.endGame()), dismissalPolicy: .default)
        }
    }
}
