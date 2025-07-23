import UIKit

final class TrackerCell: UICollectionViewCell {
    
    private let cardView = UIView()
    
    private let headerView = UIView()
    private let emojiBackgroundView = UIView()
    private let emojiLabel = UILabel()
    private let titleLabel = UILabel()
    
    private let footerView = UIView()
    private let countLabel = UILabel()
    private let plusButton = UIButton()
    
    var onToggle: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.clipsToBounds = true
        contentView.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 148)
        ])
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.layer.cornerRadius = 16
        headerView.clipsToBounds = true
        cardView.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: cardView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(footerView)
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        emojiBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        emojiBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        emojiBackgroundView.layer.cornerRadius = 12
        emojiBackgroundView.clipsToBounds = true
        headerView.addSubview(emojiBackgroundView)
        
        NSLayoutConstraint.activate([
            emojiBackgroundView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalTo: emojiBackgroundView.widthAnchor)
        ])
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.font = .systemFont(ofSize: 16)
        emojiLabel.textAlignment = .center
        emojiBackgroundView.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byWordWrapping
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12)
        ])
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textColor = .black
        countLabel.font = .systemFont(ofSize: 12, weight: .medium)
        footerView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 16),
        ])
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.layer.cornerRadius = 17
        plusButton.clipsToBounds = true
        plusButton.tintColor = UIColor(named: "trackerWhite")
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        footerView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            plusButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12),
            plusButton.centerYAnchor.constraint(equalTo: countLabel.centerYAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 34),
            plusButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    @objc private func plusButtonTapped() {
        onToggle?()
    }
    
    func configure(with tracker: Tracker, isCompletedToday: Bool, completedDays: Int, isPlusbuttonEnabled: Bool) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        emojiLabel.attributedText = NSAttributedString(string: tracker.emoji, attributes: attributes)
        
        titleLabel.text = tracker.name
        headerView.backgroundColor = tracker.color
        
        countLabel.text = "\(completedDays) дней"
        
        let buttonImage = isCompletedToday ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        plusButton.setImage(buttonImage, for: .normal)
        
        let buttonColor = tracker.color
        plusButton.backgroundColor = isCompletedToday ? buttonColor.withAlphaComponent(0.3) : buttonColor
        
        setPlusButtonEnabled(isPlusbuttonEnabled)
    }
    
    func setPlusButtonEnabled(_ enabled: Bool) {
        plusButton.isUserInteractionEnabled = enabled
        plusButton.alpha = enabled ? 1.0 : 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
