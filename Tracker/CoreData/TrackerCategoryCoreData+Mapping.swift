import CoreData

extension TrackerCategoryCoreData {
    func toTrackerCategory() -> TrackerCategory? {
        guard let title = self.title else { return nil }
        
        let trackers = (self.trackers?.allObjects as? [TrackerCoreData])?.compactMap { $0.toTracker() } ?? []
        
        return TrackerCategory(
            title: title,
            trackers: trackers
        )
    }
    
    func update(from category: TrackerCategory) {
        self.title = category.title
    }
}
