import Foundation

@objc(CodableWeekdaySetTransformer)
final class CodableWeekdaySetTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let weekdays = value as? Set<Weekday> else {
            print("⚠️ CodableWeekdaySetTransformer: Input is not Set<Weekday>")
            return nil
        }
        
        do {
            let data = try JSONEncoder().encode(weekdays)
            return data
        } catch {
            print("❌ CodableWeekdaySetTransformer: Encoding error: \(error)")
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            print("⚠️ CodableWeekdaySetTransformer: Input is not Data")
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(Set<Weekday>.self, from: data)
            return decoded
        } catch {
            print("❌ CodableWeekdaySetTransformer: Decoding error: \(error)")
            return nil
        }
    }
}
