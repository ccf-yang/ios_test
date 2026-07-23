import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("当前系统时间: \(Date().formatted(date: .abbreviated, time: .standard))")
                    .font(.headline)
                    .padding()
                
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
            .sheet(isPresented: $viewModel.isShowingDetail) {
                EventDetailSheet(events: viewModel.selectedDateEvents, date: viewModel.selectedDate)
            }
        }
        .onAppear {
            viewModel.fetchMarkedDates()
        }
    }
}
