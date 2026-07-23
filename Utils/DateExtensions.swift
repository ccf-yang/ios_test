import Foundation

extension Date {
    // 获取当天的 0:00 (用于数据库查询范围)
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    // 获取当天的 23:59:59
    func endOfDay() -> Date {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: self)
        return calendar.date(byAdding: .day, value: 1, to: start) ?? self
    }
}
