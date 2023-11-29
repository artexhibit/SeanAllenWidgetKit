import Foundation

protocol GameSimulatorDelegate: AnyObject {
    func didUpdate(gameState: GameState)
    func didCompleteGame()
}

final class GameSimulator {
    var homeTeam: Team
    var awayTeam: Team
    var homeScore: Int = 0
    var awayScore: Int = 0
    var homePossession = true

    var scoringTeam: Team {
        homePossession ? homeTeam : awayTeam
    }

    var possessionCount = 0
    var timer: Timer?

    weak var delegate: GameSimulatorDelegate!

    init() {
        self.homeTeam = Team(name: "warriors", players: ["S. Curry",
                                                        "K. Thompson",
                                                        "A. Wiggins",
                                                        "D. Green",
                                                        "K. Looney"])

        self.awayTeam = Team(name: "bulls", players: ["R. Harper",
                                                     "M. Jordan",
                                                     "S. Pippen",
                                                     "D. Rodman",
                                                     "L. Longley"])
    }

    func start() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runGameSimulator), userInfo: nil, repeats: true)
    }

    @objc func runGameSimulator() {
        delegate.didUpdate(gameState: progressGame())

        guard possessionCount <= 120 else {
            delegate.didCompleteGame()
            return
        }

        possessionCount += 1
    }

    func end() {
        delegate.didUpdate(gameState: endGame())
    }

    func reset() {
        timer?.invalidate()
        homeScore = 0
        awayScore = 0
        possessionCount = 0
        homePossession = true
    }


    func progressGame() -> GameState {
        let pointsScored = Int.random(in: 0...3)
        homePossession ? (homeScore += pointsScored) : (awayScore += pointsScored)

        let lastAction = createLastActionString(scoringTeam: scoringTeam, pointsScored: pointsScored)

        // Capture scoring team before toggling possession
        let scoringTeamName = scoringTeam.name
        homePossession.toggle()

        return GameState(homeScore: homeScore,
                         awayScore: awayScore,
                         scoringTeamName: scoringTeamName,
                         lastAction: lastAction)
    }

    func endGame() -> GameState {
        let finalHomeScore = homeScore
        let finalAwayScore = awayScore
        let winningTeam = finalHomeScore > finalAwayScore ? homeTeam : awayTeam

        reset()

        return GameState(homeScore: finalHomeScore,
                         awayScore: finalAwayScore,
                         scoringTeamName: winningTeam.name,
                         lastAction: "The game has ended. \(winningTeam.name.capitalized) win!!")
    }


    func createLastActionString(scoringTeam: Team, pointsScored: Int) -> String {

        let scoringPlayer = scoringTeam.players.randomElement() ?? "Player"

        switch pointsScored {
        case 0:
            return scoringPlayer + " " + "missed a shot"
        case 1:
            return scoringPlayer + " " + "made 1 of 2 free throws"
        case 2:
            return scoringPlayer + " " + "lays it in for 2"
        case 3:
            return scoringPlayer + " " + "drains a 3"
        default:
            return scoringPlayer + " " + "had a 4 point play!"
        }
    }
}
