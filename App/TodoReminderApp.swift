import SwiftUI

@main
struct TodoReminderApp: App {
    // 修改点：不再使用 @StateObject
    private let persistenceController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
