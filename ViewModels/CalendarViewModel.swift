import Foundation
import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var markedDates: Set<DateComponents> = []
    @Published var selectedDateEvents: [EventItem] = []
    @Published var isShowingDetail: Bool = false
    @Published var selectedDate: Date = Date()
    
    private let persistence = PersistenceController.shared
    
    init() {
        fetchMarkedDates()
    }
    
    // 拉取所有有记录的日期
    func fetchMarkedDates() {
        let dates = persistence.fetchEventDates()
        let calendar = Calendar.current
        markedDates = Set(dates.map { calendar.dateComponents([.year, .month, .day], from: $0) })
    }
    
    // 点击日历某一天
    func selectDate(_ date: Date) {
        selectedDate = date
        selectedDateEvents = persistence.fetchEvents(for: date)
        if !selectedDateEvents.isEmpty {
            isShowingDetail = true
        }
    }
}
