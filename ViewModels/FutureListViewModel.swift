import Foundation
import SwiftUI

class FutureListViewModel: ObservableObject {
    @Published var futureEvents: [EventItem] = []
    
    private let persistence = PersistenceController.shared
    
    init() {
        fetchFutureEvents()
    }
    
    func fetchFutureEvents() {
        futureEvents = persistence.fetchFutureEvents()
    }
    
    func deleteEvent(at offsets: IndexSet) {
        offsets.forEach { index in
            let event = futureEvents[index]
            persistence.deleteEvent(event: event)
        }
        fetchFutureEvents()
    }
}
