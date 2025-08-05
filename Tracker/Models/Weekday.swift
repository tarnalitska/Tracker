import Foundation

enum Weekday: String, CaseIterable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

extension Weekday {
    var localizedName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
            
        }
    }
    
    static func weekday(from calendarWeekday: Int) -> Weekday {
        switch calendarWeekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        } 
    }
}

extension Weekday {
    static func from(rawValue: String) -> Set<Weekday> {
        let components = rawValue.components(separatedBy: ",")
        return Set(components.compactMap { Weekday(rawValue: $0) })
    }
    
    static func toRawValue(from weekdays: Set<Weekday>) -> String {
        weekdays.map { $0.rawValue }.joined(separator: ",")
    }
}

