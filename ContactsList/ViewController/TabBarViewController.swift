//
//  TabBarViewController.swift
//  ContactsList
//
//  Created by Pavel on 19.12.22.
//

import RAMAnimatedTabBarController

final class TabBarViewController: RAMAnimatedTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        let contactsViewController = ContactsViewController()
        let favouriteContactsViewController = FavouriteContactsViewController()

        contactsViewController.tabBarItem = RAMAnimatedTabBarItem(title: "Contacts", image: UIImage(systemName: "person.2.circle.fill"), tag: 1)
        (contactsViewController.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMFlipTopTransitionItemAnimations()

        favouriteContactsViewController.tabBarItem = RAMAnimatedTabBarItem(title: "Favourite", image: UIImage(systemName: "heart.fill"), tag: 2)
        (favouriteContactsViewController.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMFlipTopTransitionItemAnimations()

        setViewControllers([contactsViewController, favouriteContactsViewController], animated: false)
    }
}
