import ActivityKit
import WidgetKit
import SwiftUI

struct GameAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var gameState: GameState
    }

    // Fixed non-changing properties about your activity go here!
    var homeTeam: String
    var awayTeam: String
}

struct GameLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: GameAttributes.self) { context in
            // Lock screen/banner UI goes here
            LiveActivityView()

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image("warriors")
                            .teamLogoModifier(frame: 40)
                        
                        Text("100")
                            .font(.title)
                            .fontWeight(.semibold)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("88")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Image("bulls")
                            .teamLogoModifier(frame: 40)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Image("warriors")
                            .teamLogoModifier(frame: 20)
                        
                        Text("S.Curry drains a 3")
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("5:24 3Q")
                }
            } compactLeading: {
                HStack {
                    Image("warriors")
                        .teamLogoModifier()
                    
                    Text("100")
                        .fontWeight(.semibold)
                }
            } compactTrailing: {
                HStack {
                    Text("88")
                        .fontWeight(.semibold)
                    
                    Image("bulls")
                        .teamLogoModifier()
                }
            } minimal: {
                Image("warriors")
                    .teamLogoModifier()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension GameAttributes {
    fileprivate static var preview: GameAttributes {
        GameAttributes(homeTeam: "", awayTeam: "")
    }
}

extension GameAttributes.ContentState {
    fileprivate static var smiley: GameAttributes.ContentState {
        GameAttributes.ContentState(gameState: GameState(homeScore: 1, awayScore: 3, scoringTeamName: "", lastAction: ""))
     }
     
     fileprivate static var starEyes: GameAttributes.ContentState {
         GameAttributes.ContentState(gameState: GameState(homeScore: 1, awayScore: 3, scoringTeamName: "", lastAction: ""))
     }
}

#Preview("Notification", as: .content, using: GameAttributes.preview) {
   GameLiveActivity()
} contentStates: {
    GameAttributes.ContentState.smiley
    GameAttributes.ContentState.starEyes
}
