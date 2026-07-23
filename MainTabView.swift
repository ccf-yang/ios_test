import SwiftUI

struct MainTabView: View {
    var body: some View { 
        TabView {
            CalendarView()
                .tabItem {
                    Label("日历", systemImage: "calendar")
                }
            
            AddRecordView()
                .tabItem {
                    Label("新增", systemImage: "plus.circle.fill")
                }
            
            FutureListView()
                .tabItem {
                    Label("待办", systemImage: "list.bullet")
                }
        }
    }
}
