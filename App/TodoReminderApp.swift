import SwiftUI

@main
struct TodoReminderApp: App {
    // 初始化全局数据库控制器
    @StateObject private var persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
