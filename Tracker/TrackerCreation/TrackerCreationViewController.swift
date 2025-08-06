import UIKit

final class TrackerCreationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var categoryButtonToTextFieldConstraint: NSLayoutConstraint!
    private var categoryButtonToErrorLabelConstraint: NSLayoutConstraint!
    let viewModel = TrackerCreationViewModel()
    
    var onScheduleSelect: (() -> Void)?
    var onCancel: (() -> Void)?
    var onCreateTracker: ((String, String, String, UIColor) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = UIColor(named: "trackerLightGray")?.withAlphaComponent(0.3) ?? .systemGray6
        textField.layer.cornerRadius = 10
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "Emoji"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        return collectionView
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        return collectionView
    }()
    
    private let nameErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = UIColor(named: "trackerRed") ?? .systemRed
        label.font = .systemFont(ofSize: 17)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Категория", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(UIColor(named: "trackerBlack"), for: .normal)
        button.backgroundColor = UIColor(named: "trackerLightGray")?.withAlphaComponent(0.3) ?? .systemGray6
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        button.configuration = config
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let underline: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "trackerGray")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryChevronImageView: UIImageView = {
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: boldConfig))
        chevronImageView.tintColor = UIColor(named: "trackerGray")
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        return chevronImageView
    }()
    
    private let scheduleChevronImageView: UIImageView = {
        let boldConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right", withConfiguration: boldConfig))
        chevronImageView.tintColor = UIColor(named: "trackerGray")
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        return chevronImageView
    }()
    
    private let scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Расписание", for: .normal)
        button.contentHorizontalAlignment = .leading
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = UIColor(named: "trackerLightGray")?.withAlphaComponent(0.3) ?? .systemGray6
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        button.configuration = config
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(named: "trackerRed"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.borderColor = UIColor(named: "trackerRed")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(UIColor(named: "trackerWhite"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(named: "trackerGray")
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceVertical = true
        setupUI()
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged(_:)), for: .editingChanged)
        
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewContentSize()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(nameErrorLabel)
        contentView.addSubview(categoryButton)
        contentView.addSubview(scheduleButton)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorLabel)
        contentView.addSubview(colorCollectionView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        categoryButton.addSubview(underline)
        categoryButton.addSubview(categoryChevronImageView)
        scheduleButton.addSubview(scheduleChevronImageView)
        
        categoryButtonToTextFieldConstraint = categoryButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24)
        categoryButtonToErrorLabelConstraint = categoryButton.topAnchor.constraint(equalTo: nameErrorLabel.bottomAnchor, constant: 24)
        
        categoryButtonToTextFieldConstraint.isActive = true
        categoryButtonToErrorLabelConstraint.isActive = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            nameErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            nameErrorLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameErrorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            underline.heightAnchor.constraint(equalToConstant: 0.5),
            underline.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            underline.centerXAnchor.constraint(equalTo: categoryButton.centerXAnchor),
            underline.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            underline.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            
            categoryChevronImageView.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryChevronImageView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -24),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleChevronImageView.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleChevronImageView.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -24),
            
            emojiLabel.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            
            emojiCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 24),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156),
            
            colorLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            colorCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 24),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 170),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func categoryButtonTapped() {
        print("Category tapped ✅")
    }
    
    @objc private func scheduleButtonTapped() {
        onScheduleSelect?()
    }
    
    @objc private func cancelButtonTapped() {
        onCancel?()
    }
    
    @objc private func createButtonTapped() {
        guard let name = viewModel.name,
              let selectedEmoji = viewModel.selectedEmoji,
              let selectedColor = viewModel.selectedColor else {
            print("🚫 Не хватает данных для создания трекера")
            return
        }
        
        if name.count >= 38 {
            nameErrorLabel.isHidden = false
            print("❌ Название слишком длинное")
            return
        }
        
        nameErrorLabel.isHidden = true
        
        onCreateTracker?(name, "Мои трекеры", selectedEmoji, selectedColor)
    }
    
    @objc private func nameTextFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        viewModel.name = text
        
        let hasError = text.count >= 38
        nameErrorLabel.isHidden = !hasError
        
        if hasError {
            nameErrorLabel.text = "Ограничение 38 символов"
            nameErrorLabel.textColor = .systemRed
            
            categoryButtonToTextFieldConstraint.isActive = false
            categoryButtonToErrorLabelConstraint.isActive = true
        } else {
            nameErrorLabel.isHidden = true
            
            categoryButtonToErrorLabelConstraint.isActive = false
            categoryButtonToTextFieldConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Keyboard Handling
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height + 20
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
    
    // MARK: - TextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            return updatedText.count <= 38
        }
        return true
    }
    
    private func updateScrollViewContentSize() {
        let contentHeight = colorCollectionView.frame.maxY + 60 
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackerCreationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return viewModel.emojis.count
        } else if collectionView == colorCollectionView {
            return viewModel.colors.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as! EmojiCell
            let emoji = viewModel.emojis[indexPath.item]
            cell.configure(with: emoji, isSelected: viewModel.selectedEmoji == emoji)
            return cell
        } else if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
            let color = viewModel.colors[indexPath.item]
            cell.configure(with: color, isSelected: viewModel.selectedColor == color)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension TrackerCreationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            let emoji = viewModel.emojis[indexPath.item]
            viewModel.selectEmoji(emoji)
            collectionView.reloadData()
        } else if collectionView == colorCollectionView {
            let color = viewModel.colors[indexPath.item]
            viewModel.selectColor(color)
            collectionView.reloadData()
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: points, height: 75))
        leftView = paddingView
        leftViewMode = .always
    }
}
