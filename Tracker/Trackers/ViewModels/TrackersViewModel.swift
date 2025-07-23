import Foundation

final class TrackersViewModel {
    
    private(set) var categories: [TrackerCategory] = []
    private(set) var filteredCategories: [TrackerCategory] = []
    
    private(set) var selectedDate: Date = Date() {
        didSet {
            filterCategories(for: selectedDate)
        }
    }
    
    private(set) var completedRecords: [TrackerRecord] =  []
    {
        didSet {
            onRecordsChanged?()
        }
    }
    
    var onCategoriesUpdated: (() -> Void)?
    var onRecordsChanged: (() -> Void)?
    
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
        if let index = completedRecords.firstIndex(where: { $0.trackerID == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            completedRecords.remove(at: index)
        } else {
            completedRecords.append(TrackerRecord(trackerID: tracker.id, date: date))
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
