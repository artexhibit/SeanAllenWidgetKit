import Foundation

final class GameModel: ObservableObject, GameSimulatorDelegate {

    @Published var gameState = GameState(homeScore: 0,
                                          awayScore: 0,
                                          scoringTeamName: "",
                                          lastAction: "")
    let simulator = GameSimulator()

    init() {
        simulator.delegate = self
    }

    func didUpdate(gameState: GameState) {
        self.gameState = gameState
    }

    func didCompleteGame() {

    }


    // Live Activity code goes here
}
