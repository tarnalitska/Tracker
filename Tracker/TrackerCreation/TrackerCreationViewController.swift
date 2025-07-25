import UIKit

final class TrackerCreationViewController: UIViewController, UITextFieldDelegate {
    
    private var categoryButtonToTextFieldConstraint: NSLayoutConstraint!
    private var categoryButtonToErrorLabelConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        scheduleButton.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(nameErrorLabel)
        view.addSubview(categoryButton)
        view.addSubview(scheduleButton)
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
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            nameErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            nameErrorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameErrorLabel.heightAnchor.constraint(equalToConstant: 20),
            
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            
            underline.heightAnchor.constraint(equalToConstant: 0.5),
            underline.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            underline.centerXAnchor.constraint(equalTo: categoryButton.centerXAnchor),
            underline.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
            underline.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            
            categoryChevronImageView.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryChevronImageView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -24),
            
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleChevronImageView.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleChevronImageView.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -24),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161),
        ])
    }
    
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
        guard let name = nameTextField.text, !name.isEmpty else {
            print("Name is empty")
            return
        }
        
        if name.count >= 38 {
            nameErrorLabel.isHidden = false
            print("❌ Название слишком длинное")
            return
        }
        
        nameErrorLabel.isHidden = true
        
        onCreateTracker?(name, "Мои трекеры", "🙂", UIColor(named: "trackerGreen") ?? .systemGreen)
    }
    
    @objc private func nameTextFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
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
}

extension UITextField {
    func setLeftPaddingPoints(_ points: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: points, height: 75))
        leftView = paddingView
        leftViewMode = .always
    }
}
