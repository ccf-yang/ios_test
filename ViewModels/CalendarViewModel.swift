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
        
        // 监听全局广播：当新增数据保存成功时，立即刷新红点
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataChanged),
            name: NSNotification.Name("EventDataChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleDataChanged() {
        DispatchQueue.main.async { [weak self] in
            self?.fetchMarkedDates()
        }
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
