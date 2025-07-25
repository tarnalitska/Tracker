import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
}

struct Schedule {
    let days: Set<Weekday>
}
