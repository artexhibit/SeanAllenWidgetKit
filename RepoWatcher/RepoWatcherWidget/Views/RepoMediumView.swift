import SwiftUI
import WidgetKit

struct RepoMediumView: View {
    let repo: Repository
    let formatter = ISO8601DateFormatter()
        var daysSinceLastActivity: Int {
            calculateDaysSinceLastActivity(from: repo.pushedAt)
        }
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(uiImage: UIImage(data: repo.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text(repo.name)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                    }
                    .padding(.bottom, 6)
                    
                    HStack {
                        StatLabel(value: repo.watchers, systemImageName: "star.fill")
                        StatLabel(value: repo.forks, systemImageName: "tuningfork")
                        if repo.hasIssues {
                            StatLabel(value: repo.openIssues, systemImageName: "exclamationmark.triangle.fill")
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("\(daysSinceLastActivity)")
                        .bold()
                        .font(.system(size: 70))
                        .frame(width: 90)
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)
                        .foregroundColor(daysSinceLastActivity > 50 ? .pink : .green)
                        .contentTransition(.numericText())
                    
                    Text("days ago")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        
        func calculateDaysSinceLastActivity(from dateString: String) -> Int {
            let lastActivityDate = formatter.date(from: dateString) ?? .now
            let daysSinceLastAvtivity = Calendar.current.dateComponents([.day], from: lastActivityDate, to: .now).day ?? 0
            
            return daysSinceLastAvtivity
        }
}

fileprivate struct StatLabel: View {
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label(
            title: {
                Text("\(value)")
                    .font(.footnote)
                    .contentTransition(.numericText())
            },
            icon: {
                Image(systemName: "\(systemImageName)")
                    .foregroundColor(.green)
            }
        )
        .fontWeight(.medium)
    }
}

