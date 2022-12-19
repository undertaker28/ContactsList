//
//  TabBarViewController.swift
//  ContactsList
//
//  Created by Pavel on 19.12.22.
//

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor.red
        configure()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }

        let timeInterval: TimeInterval = 0.3
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
    
    func configure() {
        let contactsViewController = ContactsViewController()
        let favouriteContactsViewController = FavouriteContactsViewController()

        contactsViewController.tabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "person.2.circle"), tag: 1)

        favouriteContactsViewController.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), tag: 2)

        setViewControllers([contactsViewController, favouriteContactsViewController], animated: false)
    }
}
