//
//  TabBarViewController.swift
//  ContactsList
//
//  Created by Pavel on 19.12.22.
//

import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configure()
    }

    func setupTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "TabBarBackgroundColor")
        UITabBar.appearance().tintColor = UIColor(named: "UIElementsColor")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    func configure() {
        let contactsViewController = UINavigationController(rootViewController: ContactsViewController())
        let favouriteContactsViewController = UINavigationController(rootViewController: FavouriteContactsViewController())

        contactsViewController.tabBarItem = UITabBarItem(title: "Contacts".localized(), image: UIImage(systemName: "person.2.circle"), tag: 1)
        contactsViewController.tabBarItem.selectedImage = UIImage(systemName: "person.2.circle.fill")

        favouriteContactsViewController.tabBarItem = UITabBarItem(title: "Favourite".localized(), image: UIImage(systemName: "heart"), tag: 2)
        favouriteContactsViewController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")

        setViewControllers([contactsViewController, favouriteContactsViewController], animated: false)
    }
}
