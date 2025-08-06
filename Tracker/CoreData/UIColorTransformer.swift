import UIKit

@objc(UIColorTransformer)
final class UIColorTransformer: NSSecureUnarchiveFromDataTransformer {
    override static var allowedTopLevelClasses: [AnyClass] {
        return [UIColor.self]
    }
    
    static let name = NSValueTransformerName(rawValue: String(describing: UIColorTransformer.self))
    
    public static func register() {
        let transformer = UIColorTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
