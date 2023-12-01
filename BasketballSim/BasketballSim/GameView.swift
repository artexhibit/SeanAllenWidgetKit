import SwiftUI

struct GameView: View {
    @StateObject var model: GameModel

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Home Team
                HStack(spacing: 20) {
                    Image(model.simulator.homeTeam.name)
                        .teamLogoModifier(frame: 80)

                    Text("\(model.gameState.homeScore)")
                        .font(.system(size: 38, weight: .bold))
                }

                Spacer()

                // Away Team
                HStack(spacing: 20) {
                    Text("\(model.gameState.awayScore)")
                        .font(.system(size: 38, weight: .bold))

                    Image(model.simulator.awayTeam.name)
                        .teamLogoModifier(frame: 80)
                }
            }
            .padding(20)

            // Last Scored
            HStack {
                Image(model.gameState.scoringTeamName)
                    .teamLogoModifier(frame: 20)

                Text(model.gameState.lastAction)
            }
            .font(.callout)
            .fontWeight(.semibold)
            .padding(.bottom, 40)

            // Buttons
            VStack(spacing: 12) {
                Button("Start Game Sim") {
                    model.simulator.start()
                }
                .buttonStyle(ActionButton())

                Button("Start Live Activity") {
                    model.startLiveActivity()
                }
                .buttonStyle(ActionButton(color: .mint))

                Button("End Sim & Live Activity") {
                    model.simulator.end()
                }
                .buttonStyle(ActionButton(color: .pink))
            }
        }
    }
}

#Preview {
    GameView(model: GameModel())
}
