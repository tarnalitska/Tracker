import UIKit

final class EmojiCell: UICollectionViewCell {
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            layer.backgroundColor = isSelected ?  UIColor.trackerLightGray.cgColor : UIColor.clear.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    func configure(with emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        layer.backgroundColor = isSelected ? UIColor.trackerLightGray.cgColor : UIColor.clear.cgColor
    }
}
