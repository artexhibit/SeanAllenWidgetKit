import Foundation

struct StreaksCalculator {
    static func calculateStreakValue(for days: [Day]) -> Int {
        guard !days.isEmpty else { return 0 }
        
        let nonFutureDays = days.filter { $0.date!.dayInt <= Date().dayInt }
        var currentStreak = 0
        var longestStreak = 0
        
        for day in nonFutureDays.reversed() {
            if day.didStudy {
                currentStreak += 1
                
                if currentStreak > longestStreak {
                    longestStreak = currentStreak
                }
            } else {
                currentStreak = 0
            }
        }
        return longestStreak
    }
}
