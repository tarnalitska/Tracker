import UIKit

final class ColorCell: UICollectionViewCell {
    
    private let outerBorderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let innerColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.trackerWhite.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(outerBorderView)
        outerBorderView.translatesAutoresizingMaskIntoConstraints = false
        outerBorderView.addSubview(innerColorView)
        innerColorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outerBorderView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            outerBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            outerBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            outerBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            innerColorView.topAnchor.constraint(equalTo: outerBorderView.topAnchor, constant: 3),
            innerColorView.bottomAnchor.constraint(equalTo: outerBorderView.bottomAnchor, constant: -3),
            innerColorView.leadingAnchor.constraint(equalTo: outerBorderView.leadingAnchor, constant: 3),
            innerColorView.trailingAnchor.constraint(equalTo: outerBorderView.trailingAnchor, constant: -3),
            
        ])
    }
    
    func configure(with color: UIColor, isSelected: Bool) {
        innerColorView.backgroundColor = color
        outerBorderView.layer.borderWidth = isSelected ? 3 : 0
        outerBorderView.layer.borderColor = isSelected ? color.withAlphaComponent(0.3).cgColor : nil
    }
}

