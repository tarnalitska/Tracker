import Foundation

final class TrackersViewModel {
    
    let trackerStore: TrackerStore
    let categoryStore: TrackerCategoryStore
    let recordStore: TrackerRecordStore
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var filteredCategories: [TrackerCategory] = []
    
    private(set) var selectedDate: Date = Date() {
        didSet {
            filterCategories(for: selectedDate)
        }
    }
    
    private(set) var completedRecords: [TrackerRecord] = [] {
        didSet {
            onRecordsChanged?()
        }
    }
    
    var onCategoriesUpdated: (() -> Void)?
    var onRecordsChanged: (() -> Void)?
    
    init() {
        self.trackerStore = TrackerStore()
        self.categoryStore = TrackerCategoryStore()
        self.recordStore = TrackerRecordStore()
        
        self.trackerStore.delegate = self
        
        loadCompletedRecords()
    }
    
    private func loadCompletedRecords() {
        do {
            completedRecords = try recordStore.fetchAll()
        } catch {
            print("Ошибка загрузки записей: \(error)")
            completedRecords = []
        }
    }
    
    func setCategories(_ categories: [TrackerCategory]) {
        self.categories = categories
        filterCategories(for: selectedDate)
    }
    
    func updateSelectedDate(_ date: Date) {
        selectedDate = date
    }
    
    func isCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        completedRecords.contains { $0.trackerID == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)}
    }
    
    func toggleCompleted(_ tracker: Tracker, on date: Date) {
        do {
            if let index = completedRecords.firstIndex(where: {
                $0.trackerID == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)
            }) {
                let recordToDelete = completedRecords[index]
                try recordStore.delete(recordToDelete)
                completedRecords.remove(at: index)
            } else {
                let newRecord = TrackerRecord(trackerID: tracker.id, date: date)
                try recordStore.save(newRecord)
                completedRecords.append(newRecord)
            }
        } catch {
            print("Ошибка при изменении состояния трекера: \(error)")
        }
    }
    
    func completedDaysCount(for tracker: Tracker) -> Int {
        completedRecords.filter { $0.trackerID == tracker.id }.count
    }
    
    private func filterCategories(for date: Date) {
        let weekday = Calendar.current.component(.weekday, from: date)
        let mappedWeekday = Weekday.weekday(from: weekday)
        
        filteredCategories = categories.compactMap { category in
            let trackersForDay = category.trackers.filter { tracker in
                tracker.schedule.days.contains(mappedWeekday)
            }
            if trackersForDay.isEmpty {
                return nil
            } else {
                return TrackerCategory(title: category.title, trackers: trackersForDay)
            }
        }
        
        onCategoriesUpdated?()
    }
}

extension TrackersViewModel: TrackerStoreDelegate {
    func trackerStoreDidUpdate() {
        do {
            let categories = try categoryStore.fetchAll()
            setCategories(categories)
        } catch {
            print("Ошибка обновления категорий: \(error)")
        }
    }
}
