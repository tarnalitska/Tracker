import UIKit

final class ScheduleViewController: UIViewController {
    
    var onScheduleSelected: ((Set<Weekday>) -> Void)?
    
    private var selectedDays: Set<Weekday> = []
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor(named: "trackerWhite"), for: .normal)
        button.backgroundColor = UIColor(named: "trackerBlack")
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let days = Weekday.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupDoneButton()
        setupTitle()
    }
    
    private func setupTitle() {
        let label = UILabel()
        label.text = "Расписание"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(named: "trackerWhite")
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorColor = UIColor(named: "trackerGray")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(named: "trackerLightGray")?.withAlphaComponent(0.3) ?? .systemGray6
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.isScrollEnabled = false
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(days.count) * 75)
        ])
    }
    
    private func setupDoneButton() {
        view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneTapped() {        onScheduleSelected?(selectedDays)
    }
}

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weekday = days[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath) as! ScheduleCell
        cell.configure(with: weekday, isOn: selectedDays.contains(weekday))
        cell.onToggle = { [weak self] isOn in
            if isOn {
                self?.selectedDays.insert(weekday)
            } else {
                self?.selectedDays.remove(weekday)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == days.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
