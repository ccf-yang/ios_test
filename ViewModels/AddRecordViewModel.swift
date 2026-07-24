import Foundation
import SwiftUI

class AddRecordViewModel: ObservableObject {
    @Published var content: String = ""
    @Published var eventDate: Date = Date()
    
    private let persistence = PersistenceController.shared
    
    func saveEvent() {
        guard !content.isEmpty else { return }
        persistence.addEvent(date: eventDate, content: content)
        
        // 保存成功后，发送全局广播通知其他页面刷新
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("EventDataChanged"), object: nil)
        }
        
        // 重置表单
        content = ""
        eventDate = Date()
    }
}
