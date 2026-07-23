import Foundation
import CoreData

// 程序化对应的实体类
@objc(EventItem)
public class EventItem: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var eventDate: Date
    @NSManaged public var content: String
    @NSManaged public var createdAt: Date
}

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // 修改点：去掉了 private，让 App 层可以初始化
    init() {
        let model = PersistenceController.createManagedObjectModel()
        container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    private static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "EventItem"
        entity.managedObjectClassName = "EventItem"
        
        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .UUIDAttributeType
        idAttr.isOptional = false
        
        let eventDateAttr = NSAttributeDescription()
        eventDateAttr.name = "eventDate"
        eventDateAttr.attributeType = .dateAttributeType
        eventDateAttr.isOptional = false
        
        let contentAttr = NSAttributeDescription()
        contentAttr.name = "content"
        contentAttr.attributeType = .stringAttributeType
        contentAttr.isOptional = false
        
        let createdAtAttr = NSAttributeDescription()
        createdAtAttr.name = "createdAt"
        createdAtAttr.attributeType = .dateAttributeType
        createdAtAttr.isOptional = false
        
        entity.properties = [idAttr, eventDateAttr, contentAttr, createdAtAttr]
        model.entities = [entity]
        return model
    }
    
    // MARK: - CRUD 操作
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func addEvent(date: Date, content: String) {
        let context = container.viewContext
        let newEvent = EventItem(context: context)
        newEvent.id = UUID()
        newEvent.eventDate = date
        newEvent.content = content
        newEvent.createdAt = Date()
        saveContext()
    }
    
    func deleteEvent(event: EventItem) {
        let context = container.viewContext
        context.delete(event)
        saveContext()
    }
    
    func fetchFutureEvents() -> [EventItem] {
        let context = container.viewContext
        // 修改点：增加 as? 强转
        let fetchRequest = EventItem.fetchRequest() as! NSFetchRequest<EventItem>
        
        let currentDate = Date()
        fetchRequest.predicate = NSPredicate(format: "eventDate >= %@", currentDate as NSDate)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "eventDate", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch future events: \(error)")
            return []
        }
    }
    
    // 修改点：直接返回 EventItem 数组，避免 NSDate 类型问题
    func fetchEventDates() -> [Date] {
        let context = container.viewContext
        let fetchRequest = EventItem.fetchRequest() as! NSFetchRequest<EventItem>
        
        do {
            let events = try context.fetch(fetchRequest)
            return events.map { $0.eventDate }
        } catch {
            print("Failed to fetch event dates: \(error)")
            return []
        }
    }
    
    func fetchEvents(for date: Date) -> [EventItem] {
        let context = container.viewContext
        // 修改点：增加 as? 强转
        let fetchRequest = EventItem.fetchRequest() as! NSFetchRequest<EventItem>
        
        let startOfDay = date.startOfDay()
        let endOfDay = date.endOfDay()
        fetchRequest.predicate = NSPredicate(format: "eventDate >= %@ AND eventDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch events for date: \(error)")
            return []
        }
    }
}
