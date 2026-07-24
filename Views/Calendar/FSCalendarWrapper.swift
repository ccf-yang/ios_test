import SwiftUI
import FSCalendar

// 专门用来承接 FSCalendar 的 SwiftUI 视图
struct FSCalendarWrapper: UIViewRepresentable {
    @Binding var selectedDate: Date
    var markedDates: Set<DateComponents>
    var onSelectDate: (Date) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // 基础外观设置
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.todayColor = .systemBlue
        calendar.appearance.selectionColor = .systemGray
        
        // 开启事件圆点显示
        calendar.appearance.eventDefaultColor = .systemRed
        calendar.appearance.eventSelectionColor = .systemRed
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // 关键修改：强制将最新的数据同步给 Coordinator，并重新加载日历
        context.coordinator.parent = self
        uiView.reloadData()
    }
    
    // Coordinator 用于处理 FSCalendar 的代理方法
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: FSCalendarWrapper
        
        init(_ parent: FSCalendarWrapper) {
            self.parent = parent
        }
        
        // 处理点击事件
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            self.parent.selectedDate = date
            self.parent.onSelectDate(date)
        }
        
        // 处理圆点显示逻辑
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            
            // 如果当前日期在 markedDates 集合中，则显示 1 个圆点
            if parent.markedDates.contains(dateComponents) {
                return 1
            }
            return 0
        }
    }
}
