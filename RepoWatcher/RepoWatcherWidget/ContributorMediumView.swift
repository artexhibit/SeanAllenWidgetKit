import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
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
                ForEach(0..<4) { i in
                    HStack {
                        Image(uiImage: UIImage(named: "avatar")!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Sean Allen")
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                            Text("42")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }
}

struct ContributorMediumView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorMediumView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .containerBackground(.fill.tertiary, for: .widget)
    }
}
