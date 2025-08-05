import CoreData

protocol TrackerCategoryStoreProtocol {
    func fetchAll() throws -> [TrackerCategory]
    func save(_ category: TrackerCategory) throws
    func findOrCreate(_ category: TrackerCategory) throws -> TrackerCategoryCoreData
    func delete(_ category: TrackerCategory) throws
}

final class TrackerCategoryStore: TrackerCategoryStoreProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataProvider.shared.context) {
        self.context = context
    }
    
    func fetchAll() throws -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        let result = try context.fetch(request)
        return result.compactMap { $0.toTrackerCategory() }
    }
    
    func save(_ category: TrackerCategory) throws {
        try context.save()
    }
    
    func findOrCreate(_ category: TrackerCategory) throws -> TrackerCategoryCoreData {
        
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", category.title)
        request.fetchLimit = 1
        
        if let existingCategory = try context.fetch(request).first {
            existingCategory.update(from: category)
            return existingCategory
        } else {
            let newCategory = TrackerCategoryCoreData(context: context)
            newCategory.update(from: category)
            return newCategory
        }
    }
    
    func delete(_ category: TrackerCategory) throws {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", category.title)
        request.fetchLimit = 1
        
        if let categoryToDelete = try context.fetch(request).first {
            context.delete(categoryToDelete)
            try context.save()
        }
    }
    
    func fetchCategory(by title: String) throws -> TrackerCategory? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        
        return try context.fetch(request).first?.toTrackerCategory()
    }
}
