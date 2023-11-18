import SwiftUI

struct MonthConfig {
    let backgroundColor: Color
    let emojiText: String
    let weekDayTextColor: Color
    let dayTextColor: Color
    
    static func determineConfig(from date: Date) -> MonthConfig {
        let monthInt = Calendar.current.component(.month, from: date)
        
        switch monthInt {
        case 1:
            return MonthConfig(backgroundColor: .gray,
                               emojiText: "⛄️",
                               weekDayTextColor: .black.opacity(0.6),
                               dayTextColor: .white.opacity((0.8)))
            
        case 2:
            return MonthConfig(backgroundColor: .palePink,
                               emojiText: "❤️",
                               weekDayTextColor: .black.opacity(0.5),
                               dayTextColor: .pink.opacity((0.8)))
            
        case 3:
            return MonthConfig(backgroundColor: .paleGreen,
                               emojiText: "☘️",
                               weekDayTextColor: .black.opacity(0.7),
                               dayTextColor: .darkGreen.opacity((0.8)))
            
        case 4:
            return MonthConfig(backgroundColor: .paleBlue,
                               emojiText: "☔️",
                               weekDayTextColor: .black.opacity(0.5),
                               dayTextColor: .purple.opacity((0.8)))
            
        case 5:
            return MonthConfig(backgroundColor: .paleYellow,
                               emojiText: "🌹",
                               weekDayTextColor: .black.opacity(0.5),
                               dayTextColor: .pink.opacity((0.7)))
            
        case 6:
            return MonthConfig(backgroundColor: .skyBlue,
                               emojiText: "⛅️",
                               weekDayTextColor: .black.opacity(0.5),
                               dayTextColor: .paleYellow.opacity((0.8)))
            
        case 7:
            return MonthConfig(backgroundColor: .blue,
                               emojiText: "🏖️",
                               weekDayTextColor: .black.opacity(0.5),
                               dayTextColor: .paleBlue.opacity((0.8)))
            
        case 8:
            return MonthConfig(backgroundColor: .paleOrange,
                               emojiText: "☀️",
                               weekDayTextColor: .black.opacity(0.5),
                               dayTextColor: .darkOrange.opacity((0.8)))
            
        case 9:           
            return MonthConfig(backgroundColor: .paleRed,
                               emojiText: "🍁",
                               weekDayTextColor: .black.opacity(0.5),
                               dayTextColor: .paleYellow.opacity((0.9)))
            
        case 10:
            return MonthConfig(backgroundColor: .black,
                               emojiText: "👻",
                               weekDayTextColor: .white.opacity(0.6),
                               dayTextColor: .orange.opacity((0.8)))
            
        case 11:
            return MonthConfig(backgroundColor: .paleBrown,
                               emojiText: "🦃",
                               weekDayTextColor: .black.opacity(0.6),
                               dayTextColor: .black.opacity((0.6)))
            
            
        case 12:
            return MonthConfig(backgroundColor: .paleRed,
                               emojiText: "🎄",
                               weekDayTextColor: .white.opacity(0.9),
                               dayTextColor: .darkGreen.opacity((0.7)))
            
        default:
            return MonthConfig(backgroundColor: .gray,
                               emojiText: "📆",
                               weekDayTextColor: .black.opacity(0.6),
                               dayTextColor: .white.opacity((0.8)))
        }
    }
}
