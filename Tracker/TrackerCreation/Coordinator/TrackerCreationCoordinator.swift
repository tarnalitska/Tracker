import UIKit

final class TrackerCreationCoordinator {
    
    private let presentingViewController: UIViewController
    private var navigationController: UINavigationController?
    
    private var trackerDraft = TrackerDraft()
    
    var onFinishCreation: ((Tracker, String) -> Void)?
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func start() {
        let creationVC = TrackerCreationViewController()
        
        creationVC.onScheduleSelect = { [weak self] in
            print("➡️ onScheduleSelect called from VC")
            
            self?.showScheduleScreen()
        }
        
        creationVC.onCancel = { [weak self] in
            self?.dismiss()
        }
        
        creationVC.onCreateTracker = { [weak self] name, category, emoji, color in
            
            guard let self = self else { return }
            guard let schedule = self.trackerDraft.schedule else {
                print("🚫 Schedule не задан — трекер не создан")
                return
            }
            
            let tracker = Tracker(
                id: UUID(),
                name: name,
                color: color,
                emoji: emoji,
                schedule: schedule
            )
            
            self.onFinishCreation?(tracker, category)
            self.dismiss()
        }
        
        let navVC = UINavigationController(rootViewController: creationVC)
        navigationController = navVC
        presentingViewController.present(navVC, animated: true)
    }
    
    private func showScheduleScreen() {
        let scheduleVC = ScheduleViewController()
        
        scheduleVC.onScheduleSelected = { [weak self] selectedDays in
            self?.trackerDraft.schedule = Schedule(days: selectedDays)
            print("\(String(describing: self?.trackerDraft.schedule))")
            self?.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.pushViewController(scheduleVC, animated: true)
    }
    
    private func dismiss() {
        navigationController?.dismiss(animated: true)
        navigationController = nil
    }
}
