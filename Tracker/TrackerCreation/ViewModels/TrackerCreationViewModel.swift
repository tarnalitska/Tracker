import UIKit

final class TrackerCreationViewModel {
    let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱",
                  "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                  "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    let colors: [UIColor] = [
        UIColor(red: 0.99, green: 0.27, blue: 0.27, alpha: 1.0),
        UIColor(red: 1.00, green: 0.58, blue: 0.14, alpha: 1.0),
        UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.0),
        UIColor(red: 0.51, green: 0.25, blue: 1.00, alpha: 1.0),
        UIColor(red: 0.26, green: 0.87, blue: 0.50, alpha: 1.0),
        UIColor(red: 1.00, green: 0.45, blue: 0.87, alpha: 1.0),

        UIColor(red: 1.00, green: 0.85, blue: 0.85, alpha: 1.0),
        UIColor(red: 0.24, green: 0.72, blue: 1.00, alpha: 1.0),
        UIColor(red: 0.50, green: 1.00, blue: 0.73, alpha: 1.0),
        UIColor(red: 0.23, green: 0.21, blue: 0.47, alpha: 1.0),
        UIColor(red: 1.00, green: 0.45, blue: 0.37, alpha: 1.0),
        UIColor(red: 1.00, green: 0.75, blue: 0.85, alpha: 1.0),

        UIColor(red: 1.00, green: 0.83, blue: 0.60, alpha: 1.0),
        UIColor(red: 0.58, green: 0.70, blue: 1.00, alpha: 1.0),
        UIColor(red: 0.60, green: 0.36, blue: 1.00, alpha: 1.0),
        UIColor(red: 0.81, green: 0.51, blue: 1.00, alpha: 1.0),
        UIColor(red: 0.63, green: 0.53, blue: 1.00, alpha: 1.0),
        UIColor(red: 0.33, green: 0.87, blue: 0.38, alpha: 1.0)
    ]
    
    var name: String?
    var selectedEmoji: String?
    var selectedColor: UIColor?
    
    func selectEmoji(_ emoji: String) {
        selectedEmoji = emoji
    }
    
    func selectColor(_ color: UIColor) {
        selectedColor = color
    }
}
