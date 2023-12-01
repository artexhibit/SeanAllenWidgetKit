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
        let activityContent = ActivityContent(state: currentGameState, staleDate: nil)
        
        do {
            liveActivity = try Activity.request(attributes: attributes, content: activityContent)
        } catch {
            print(error)
        }
    }

    func didUpdate(gameState: GameState) {
        self.gameState = gameState
        let currentGameState = GameAttributes.ContentState(gameState: gameState)
        let activityContent = ActivityContent(state: currentGameState, staleDate: nil)
        
        Task {
            await liveActivity?.update(activityContent)
        }
    }

    func didCompleteGame() {
        let finalGameState = GameAttributes.ContentState(gameState: simulator.endGame())
        let activityContent = ActivityContent(state: finalGameState, staleDate: nil)
        
        Task {
            await liveActivity?.end(activityContent, dismissalPolicy: .default)
        }
    }
}
