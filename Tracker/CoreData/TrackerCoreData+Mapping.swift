import CoreData
import UIKit

extension TrackerCoreData {
    func toTracker() -> Tracker? {
        guard let id = self.id,
              let name = self.name,
              let emoji = self.emoji else {
            return nil
        }
        
        let color = (self.color as? UIColor) ?? .black
        
        let weekdays: Set<Weekday>
        if let data = self.days as? Data {
            do {
                let stringSet = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSSet.self, NSString.self], from: data) as? Set<String>
                weekdays = Set((stringSet ?? []).compactMap { Weekday(rawValue: $0) })
            } catch {
                print("🔥 Error unarchiving days: \(error)")
                weekdays = Set(Weekday.allCases)
            }
        } else {
            weekdays = Set(Weekday.allCases)
        }
        
        let schedule = Schedule(days: weekdays)
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }
    
    func update(from tracker: Tracker) {
        self.id = tracker.id
        self.name = tracker.name
        self.emoji = tracker.emoji
        self.color = tracker.color
        
        let stringSet = Set(tracker.schedule.days.map { $0.rawValue })
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: stringSet, requiringSecureCoding: false)
            self.days = data as NSObject
        } catch {
            self.days = nil
        }
    }
}

extension TrackerCoreData {
    func toTrackerWithCodable() -> Tracker? {
        guard let id = self.id,
              let name = self.name,
              let emoji = self.emoji else {
            return nil
        }
        
        let color = (self.color as? UIColor) ?? .black
        
        let weekdays: Set<Weekday>
        if let data = self.days as? Data {
            do {
                let stringArray = try JSONDecoder().decode([String].self, from: data)
                weekdays = Set(stringArray.compactMap { Weekday(rawValue: $0) })
            } catch {
                print("🔥 Error decoding days: \(error)")
                weekdays = Set(Weekday.allCases)
            }
        } else {
            weekdays = Set(Weekday.allCases)
        }
        
        let schedule = Schedule(days: weekdays)
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule
        )
    }
    
    func updateWithCodable(from tracker: Tracker) {
        self.id = tracker.id
        self.name = tracker.name
        self.emoji = tracker.emoji
        self.color = tracker.color
        
        let stringArray = Array(tracker.schedule.days.map { $0.rawValue })
        
        do {
            let data = try JSONEncoder().encode(stringArray)
            self.days = data as NSObject
        } catch {
            self.days = nil
        }
    }
}
