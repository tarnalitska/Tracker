import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersVC = TrackersViewController()
        trackersVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackers_icon"), tag: 0)
        let trackersNav = UINavigationController(rootViewController: trackersVC)
        
        let statVC = StatViewController()
        statVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "stat_icon"), tag: 1)
        let statNav = UINavigationController(rootViewController: statVC)
        
        viewControllers = [trackersNav, statNav]
    }
}
