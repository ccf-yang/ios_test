import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var currentTime = Date() // 用于存储每秒更新的时间
    
    // 每秒触发一次的定时器
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("当前系统时间: \(currentTime.formatted(date: .abbreviated, time: .standard))")
                    .font(.headline)
                    .padding()
                    .onReceive(timer) { input in
                        currentTime = input // 每秒更新时间
                    }
                
                // 使用封装的 FSCalendar
                FSCalendarWrapper(
                    selectedDate: $viewModel.selectedDate,
                    markedDates: viewModel.markedDates,
                    onSelectDate: { date in
                        viewModel.selectDate(date)
                    }
                )
                .frame(height: 350) // 给日历一个合适的高度
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("日历概览")
            .sheet(isPresented: $viewModel.isShowingDetail, onDismiss: {
                viewModel.fetchMarkedDates()
            }) {
                EventDetailSheet(events: viewModel.selectedDateEvents, date: viewModel.selectedDate)
            }
        }
        .onAppear {
            viewModel.fetchMarkedDates()
        }
    }
}
