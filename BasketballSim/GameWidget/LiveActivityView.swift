import SwiftUI
import WidgetKit

struct LiveActivityView: View {
    @Environment(\.isActivityFullscreen) var isStandBy
    let context: ActivityViewContext<GameAttributes>
    
    var body: some View {
        ZStack {
            if !isStandBy {
                Image("activity-background")
                    .resizable()
                    .overlay {
                        ContainerRelativeShape()
                            .fill(.black.opacity(0.3).gradient)
                    }
            }
            VStack(spacing: 12) {
                HStack {
                    Image(context.attributes.homeTeam)
                        .teamLogoModifier(frame: 60)
                    
                    Text("\(context.state.gameState.homeScore)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                        .contentTransition(.numericText())
                    
                    Spacer()
                    
                    Text("\(context.state.gameState.awayScore)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(isStandBy ? .white : .black.opacity(0.8))
                        .contentTransition(.numericText())
                    
                    Image(context.attributes.awayTeam)
                        .teamLogoModifier(frame: 60)
                }
                
                HStack {
                    Image(context.state.gameState.scoringTeamName)
                        .teamLogoModifier(frame: 20)
                    
                    Text(context.state.gameState.lastAction)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding()
        }
    }
}
