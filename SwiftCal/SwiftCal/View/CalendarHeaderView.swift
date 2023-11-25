import SwiftUI

struct CalendarHeaderView: View {
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    var font: Font = .body
    
    var body: some View {
        HStack {
            ForEach(daysOfWeek.indices, id: \.self) { index in
                let dayOfWeek = daysOfWeek[index]
                
                Text(dayOfWeek)
                    .font(font)
                    .fontWeight(.black)
                    .foregroundStyle(index % 7 >= 5 ? .gray : .orange)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    CalendarHeaderView()
}
