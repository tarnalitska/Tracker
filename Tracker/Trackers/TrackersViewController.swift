import UIKit

final class TrackersViewController: UIViewController {
    
    private let viewModel = TrackersViewModel()
    
    private var trackerCoordinator: TrackerCreationCoordinator?
    private var currentDate: Date = Date()
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
        
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 9
        
        let totalSpacing: CGFloat = 16 + 16 + 9
        let availableWidth = UIScreen.main.bounds.width - totalSpacing
        let itemWidth = floor(availableWidth / 2)
        
        layout.itemSize = CGSize(width: itemWidth, height: 148)
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: "TrackerCell"
        )
        
        collectionView.register(
            TrackerSectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier
        )
        
        return collectionView
    }()
    
    private lazy var emptyView: EmptyStateView = {
        let view = EmptyStateView(
            image: UIImage(named: "empty_state"),
            message: "Что будем отслеживать?"
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModelCallbacks()
        loadInitialData()
        setupUI()
    }
    
    private func setupViewModelCallbacks() {
        viewModel.onRecordsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onCategoriesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.updateEmptyState(isEmpty: self?.viewModel.filteredCategories.isEmpty ?? true)
            }
        }
    }
    
    private func loadInitialData() {
        do {
            let categories = try viewModel.categoryStore.fetchAll()
            viewModel.setCategories(categories)
            
            if categories.isEmpty {
                let defaultCategory = TrackerCategory(title: "Мои трекеры", trackers: [])
                try viewModel.categoryStore.save(defaultCategory)
                viewModel.setCategories([defaultCategory])
            }
            
            viewModel.updateSelectedDate(currentDate)
            
        } catch {
            print("Ошибка загрузки данных: \(error)")
            
            let defaultCategory = TrackerCategory(title: "Мои трекеры", trackers: [])
            viewModel.setCategories([defaultCategory])
        }
    }
    
    private func setupUI() {
        addPlusButton()
        addTitle()
        addDatePicker()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        updateEmptyState(isEmpty: viewModel.filteredCategories.isEmpty)
    }
    
    private func addTitle() {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .trackerBlack
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
    }
    
    private func addPlusButton() {
        let plusButton = UIButton(type: .system)
        plusButton.tintColor = .trackerBlack
        plusButton.contentHorizontalAlignment = .left
        plusButton.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "plus_icon")
        config.imagePlacement = .leading
        config.imagePadding = 1
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 0)
        plusButton.configuration = config
        
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        containerView.addSubview(plusButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: containerView)
    }
    
    private func addDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        viewModel.updateSelectedDate(currentDate)
    }
    
    private func updateEmptyState(isEmpty: Bool) {
        if isEmpty {
            if emptyView.superview == nil {
                view.addSubview(emptyView)
                
                NSLayoutConstraint.activate([
                    emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    emptyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    emptyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                ])
            }
        } else {
            emptyView.removeFromSuperview()
        }
    }
    
    @objc private func plusTapped() {
        if trackerCoordinator != nil {
            return
        }
        let coordinator = TrackerCreationCoordinator(presentingViewController: self)
        
        coordinator.onFinishCreation = { [weak self] tracker, categoryTitle in
            guard let self = self else { return }
            
            self.addTracker(tracker, to: categoryTitle)
            
            self.trackerCoordinator = nil
        }
        
        coordinator.onCancel = { [weak self] in
            self?.trackerCoordinator = nil
        }
        
        coordinator.start()
        trackerCoordinator = coordinator
    }
}

extension TrackersViewController {
    private func addTracker(_ tracker: Tracker, to categoryTitle: String) {
        
        do {
            let categories = try viewModel.categoryStore.fetchAll()
            
            if let existingCategory = categories.first(where: { $0.title == categoryTitle }) {
                try viewModel.trackerStore.save(tracker, to: existingCategory)
            } else {
                let newCategory = TrackerCategory(title: categoryTitle, trackers: [])
                try viewModel.categoryStore.save(newCategory)
                try viewModel.trackerStore.save(tracker, to: newCategory)
            }
        } catch {
            print("Ошибка сохранения трекера: \(error)")
        }
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filteredCategories[section].trackers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerSectionHeaderView.reuseIdentifier,
            for: indexPath
        ) as? TrackerSectionHeaderView
        
        let category = viewModel.filteredCategories[indexPath.section]
        header?.configure(title: category.title)
        
        return header ?? UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let category = viewModel.filteredCategories[indexPath.section]
        let tracker = category.trackers[indexPath.item]
        
        let selectedDate = viewModel.selectedDate
        let isFutureDate = selectedDate > Date()
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackerCell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(
            with: tracker,
            isCompletedToday: viewModel.isCompleted(tracker, on: selectedDate),
            completedDays: viewModel.completedDaysCount(for: tracker),
            isPlusbuttonEnabled: !isFutureDate
        )
        
        cell.onToggle = { [weak self] in
            guard let self = self else { return }
            
            if selectedDate <= Date() {
                self.viewModel.toggleCompleted(tracker, on: selectedDate)
            }
        }
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width,height: 36)
    }
}
