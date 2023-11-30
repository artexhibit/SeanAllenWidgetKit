import SwiftUI
import WidgetKit

struct LiveActivityView: View {
    var body: some View {
        ZStack {
            Image("activity-background")
                .resizable()
                .overlay {
                    ContainerRelativeShape()
                        .fill(.black.opacity(0.3).gradient)
                }
            
            VStack(spacing: 12) {
                HStack {
                    Image("warriors")
                        .teamLogoModifier(frame: 60)
                    
                    Text("105")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Text("105")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.black.opacity(0.8))
                    
                    Image("bulls")
                        .teamLogoModifier(frame: 60)
                }
                
                HStack {
                    Image("bulls")
                        .teamLogoModifier(frame: 20)
                    
                    Text("S. Curry drains a 3")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .padding()
        }
    }
}

#Preview {
    LiveActivityView()
}
