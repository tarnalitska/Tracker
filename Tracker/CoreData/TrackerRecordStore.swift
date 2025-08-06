import CoreData

protocol TrackerRecordStoreProtocol {
    func fetchAll() throws -> [TrackerRecord]
    func save(_ record: TrackerRecord) throws
    func delete(_ record: TrackerRecord) throws
    func fetchRecords(for trackerID: UUID) throws -> [TrackerRecord]
    func fetchRecords(for date: Date) throws -> [TrackerRecord]
}

final class TrackerRecordStore: TrackerRecordStoreProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataProvider.shared.context) {
        self.context = context
    }
    
    func fetchAll() throws -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let result = try context.fetch(request)
        return result.compactMap { $0.toTrackerRecord() }
    }
    
    func save(_ record: TrackerRecord) throws {
        let trackerRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        trackerRequest.predicate = NSPredicate(format: "id == %@", record.trackerID as CVarArg)
        trackerRequest.fetchLimit = 1
        
        guard let trackerEntity = try context.fetch(trackerRequest).first else {
            throw NSError(domain: "TrackerRecordStore", code: 1, userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
        }
        
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date >= %@ AND date < %@",
            record.trackerID as CVarArg,
            Calendar.current.startOfDay(for: record.date) as NSDate,
            Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: record.date))! as NSDate
        )
        
        if try context.fetch(request).isEmpty {
            let entity = TrackerRecordCoreData(context: context)
            entity.update(from: record, trackerEntity: trackerEntity)
            try context.save()
        }
    }
    
    func delete(_ record: TrackerRecord) throws {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "tracker.id == %@ AND date >= %@ AND date < %@",
            record.trackerID as CVarArg,
            Calendar.current.startOfDay(for: record.date) as NSDate,
            Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: record.date))! as NSDate
        )
        
        if let objectToDelete = try context.fetch(request).first {
            context.delete(objectToDelete)
            try context.save()
        }
    }
    
    func fetchRecords(for trackerID: UUID) throws -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@", trackerID as CVarArg)
        let result = try context.fetch(request)
        return result.compactMap { $0.toTrackerRecord() }
    }
    
    func fetchRecords(for date: Date) throws -> [TrackerRecord] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        let result = try context.fetch(request)
        return result.compactMap { $0.toTrackerRecord() }
    }
}
