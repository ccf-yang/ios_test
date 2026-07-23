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
    
    private init() {
        // 程序化创建 Core Data Model
        let model = PersistenceController.createManagedObjectModel()
        container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - 程序化生成数据库 Schema (替代 .xcdatamodeld)
    private static func createManagedObjectModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // 1. 创建 EventItem 实体
        let entity = NSEntityDescription()
        entity.name = "EventItem"
        entity.managedObjectClassName = "EventItem"
        
        // 2. 创建属性
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
        
        // 3. 绑定属性到实体
        entity.properties = [idAttr, eventDateAttr, contentAttr, createdAtAttr]
        
        // 4. 绑定实体到模型
        model.entities = [entity]
        
        return model
    }
    
    // MARK: - CRUD 操作
    
    // 保存数据
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // 新增记录
    func addEvent(date: Date, content: String) {
        let context = container.viewContext
        let newEvent = EventItem(context: context)
        newEvent.id = UUID()
        newEvent.eventDate = date
        newEvent.content = content
        newEvent.createdAt = Date()
        saveContext()
    }
    
    // 删除记录
    func deleteEvent(event: EventItem) {
        let context = container.viewContext
        context.delete(event)
        saveContext()
    }
    
    // 获取所有未来及当前的待办 (Tab3 使用)
    func fetchFutureEvents() -> [EventItem] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<EventItem> = EventItem.fetchRequest()
        
        // 筛选条件: eventDate >= 当前时间
        let currentDate = Date()
        let predicate = NSPredicate(format: "eventDate >= %@", currentDate as NSDate)
        fetchRequest.predicate = predicate
        
        // 按时间升序排列 (最近到未来)
        let sortDescriptor = NSSortDescriptor(key: "eventDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch future events: \(error)")
            return []
        }
    }
    
    // 获取所有有记录的日期 (Tab1 日历打点使用)
    func fetchEventDates() -> [Date] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<NSDate> = NSFetchRequest(entityName: "EventItem")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["eventDate"]
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { $0 as? Date }
        } catch {
            print("Failed to fetch event dates: \(error)")
            return []
        }
    }
    
    // 获取某一天的所有记录 (Tab1 点击某天后弹出详情使用)
    func fetchEvents(for date: Date) -> [EventItem] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<EventItem> = EventItem.fetchRequest()
        
        // 获取当天的 0:00 到 23:59
        let startOfDay = date.startOfDay()
        let endOfDay = date.endOfDay()
        let predicate = NSPredicate(format: "eventDate >= %@ AND eventDate < %@", startOfDay as NSDate, endOfDay as NSDate)
        fetchRequest.predicate = predicate
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch events for date: \(error)")
            return []
        }
    }
}
