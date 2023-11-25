import Foundation

struct StreaksCalculator {
   static func calculateStreakValue(for days: [Day]) -> Int {
       guard !days.isEmpty else { return 0 }
        
        let nonFutureDays = days.filter { $0.date!.dayInt <= Date().dayInt }
        var streakCount = 0
        
        for day in nonFutureDays.reversed() {
            if day.didStudy {
                streakCount += 1
            } else {
                if day.date!.dayInt != Date().dayInt {
                    break
                }
            }
        }
        return streakCount
    }
}
