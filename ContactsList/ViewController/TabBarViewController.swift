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
        tabBarAppearance.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(named: "TabBarItemColor")
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    func configure() {
        let contactsViewController = ContactsViewController()
        let favouriteContactsViewController = FavouriteContactsViewController()

        contactsViewController.tabBarItem = UITabBarItem(title: "Contacts", image: UIImage(systemName: "person.2.circle"), tag: 1)
        contactsViewController.tabBarItem.selectedImage = UIImage(systemName: "person.2.circle.fill")

        favouriteContactsViewController.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(systemName: "heart"), tag: 2)
        favouriteContactsViewController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")

        setViewControllers([contactsViewController, favouriteContactsViewController], animated: false)
    }
}
