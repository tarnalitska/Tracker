import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func trackerStoreDidUpdate()
}

protocol TrackerStoreProtocol {
    func fetchAll() throws -> [Tracker]
    func save(_ tracker: Tracker, to category: TrackerCategory) throws
    func delete(_ tracker: Tracker) throws
    func fetchTracker(by id: UUID) throws -> Tracker?
}

final class TrackerStore: NSObject, TrackerStoreProtocol {
    weak var delegate: TrackerStoreDelegate?
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore
    
    init(context: NSManagedObjectContext = CoreDataProvider.shared.context) {
        self.context = context
        self.categoryStore = TrackerCategoryStore(context: context)
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to setup FetchedResultsController: \(error)")
        }
    }
    
    func fetchAll() throws -> [Tracker] {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        let result = try context.fetch(request)
        return result.compactMap { $0.toTracker() }
    }
    
    func save(_ tracker: Tracker, to category: TrackerCategory) throws {
        
        let categoryEntity = try categoryStore.findOrCreate(category)
        
        let trackerEntity = TrackerCoreData(context: context)
        trackerEntity.update(from: tracker)
        trackerEntity.category = categoryEntity
        categoryEntity.addToTrackers(trackerEntity)
        
        try context.save()
    }
    
    func delete(_ tracker: Tracker) throws {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        request.fetchLimit = 1
        
        if let objectToDelete = try context.fetch(request).first {
            context.delete(objectToDelete)
            try context.save()
        }
    }
    
    func fetchTracker(by id: UUID) throws -> Tracker? {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        return try context.fetch(request).first?.toTracker()
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidUpdate()
    }
}
