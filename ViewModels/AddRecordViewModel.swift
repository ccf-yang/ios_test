import Foundation
import SwiftUI

class AddRecordViewModel: ObservableObject {
    @Published var content: String = ""
    @Published var eventDate: Date = Date()
    
    private let persistence = PersistenceController.shared
    
    func saveEvent() {
        guard !content.isEmpty else { return }
        persistence.addEvent(date: eventDate, content: content)
        
        // 重置表单
        content = ""
        eventDate = Date()
    }
}
