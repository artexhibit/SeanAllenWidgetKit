import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    let repo: Repository
    
    var body: some View {
        VStack {
            HStack {
                Text("Top Contributors")
                    .font(.caption).bold()
                    .foregroundStyle(.secondary)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2),
                      alignment: .leading,
                      spacing: 20) {
                ForEach(repo.contributors) { contributor in
                    HStack {
                        Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(contributor.login)
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .id(repo.name)
                                .transition(.push(from: .trailing))
                        }
                    }
                }
            }
            
            if repo.contributors.count < 3 {
                Spacer().frame(height: 20)
            }
        }
    }
}
