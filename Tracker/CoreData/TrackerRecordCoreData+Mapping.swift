import CoreData

extension TrackerRecordCoreData {
    func toTrackerRecord() -> TrackerRecord? {
        guard let trackerID = self.tracker?.id,
              let date = self.date else {
            return nil
        }
        
        return TrackerRecord(
            trackerID: trackerID,
            date: date
        )
    }
    
    func update(from record: TrackerRecord, trackerEntity: TrackerCoreData) {
        self.tracker = trackerEntity
        self.date = record.date
    }
}
