//
//  FavouriteContactsViewController.swift
//  ContactsList
//
//  Created by Pavel on 19.12.22.
//

import UIKit

final class FavouriteContactsViewController: UIViewController {
    private lazy var favouriteContacts = Storage.retrieve("contacts.json", from: .documents, as: [PhoneContact].self).filter { $0.isFavourite }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavouriteContactsTableCell.self, forCellReuseIdentifier: "favouriteContactsTableCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 68
        tableView.backgroundColor = UIColor(named: "BackgroundColor")
        tableView.separatorColor = UIColor(named: "ElementsInCellColor")
        tableView.tableHeaderView = UIView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(tableView)
        setupNavigationBar()
        makeConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        favouriteContacts = Storage.retrieve("contacts.json", from: .documents, as: [PhoneContact].self).filter { $0.isFavourite }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favourite".localized()
    }

    func markAsNotFavorite(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        deleteFromListOfFavourite(index: indexPathTapped)
    }

    func deleteFromListOfFavourite(index: IndexPath) {
        var phoneContacts = Storage.retrieve("contacts.json", from: .documents, as: [PhoneContact].self)
        let contact = favouriteContacts[index.row]
        let isFavourite = !contact.isFavourite
        for (index, favouriteContact) in phoneContacts.enumerated() where favouriteContact.phoneNumber == contact.phoneNumber {
            phoneContacts[index].isFavourite = isFavourite
        }
        favouriteContacts.remove(at: index.row)
        Storage.store(phoneContacts, to: .documents, as: "contacts.json")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FavouriteContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = ContactDetailViewController()
        detailsViewController.index = indexPath.row
        if favouriteContacts[indexPath.row].imageDataAvailable {
            guard let data = favouriteContacts[indexPath.row].avatarData, let contactImage = UIImage(data: data) else {
                fatalError("Couldn't get avatarData")
            }
            detailsViewController.contactImage = contactImage
        } else {
            guard let contactImage = UIImage(systemName: "person.circle.fill") else {
                fatalError("Couldn't get system image")
            }
            detailsViewController.contactImage = contactImage
        }
        detailsViewController.name = favouriteContacts[indexPath.row].name ?? ""
        detailsViewController.phoneNumber = favouriteContacts[indexPath.row].phoneNumber
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFromListOfFavourite(index: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension FavouriteContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteContactsTableCell", for: indexPath) as? FavouriteContactsTableCell else {
            fatalError("Couldn't cast cell")
        }
        cell.link = self
        cell.backgroundColor = UIColor(named: "BackgroundColor")
        cell.heartButton.isSelected = true
        if favouriteContacts[indexPath.row].imageDataAvailable {
            guard let data = favouriteContacts[indexPath.row].avatarData else {
                fatalError("Couldn't get avatarData")
            }
            cell.cellProfileImageView.image = UIImage(data: data)
        } else {
            cell.cellProfileImageView.image = UIImage(systemName: "person.circle.fill")
        }
        cell.cellName.text = favouriteContacts[indexPath.row].name
        cell.cellPhoneNumber.text = favouriteContacts[indexPath.row].phoneNumber
        return cell
    }
}
