//
//  FavouriteContactsViewController.swift
//  ContactsList
//
//  Created by Pavel on 19.12.22.
//

import UIKit

final class FavouriteContactsViewController: UIViewController {
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

    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favourite"
    }

    func deleteFromFavourite(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        var phoneContacts = Storage.retrieve("contacts.json", from: .documents, as: [PhoneContact].self)
        let contact = favouriteContacts[indexPathTapped.row]
        let isFavourite = contact.isFavourite
        for (index, favouriteContact) in phoneContacts.enumerated() where favouriteContact.phoneNumber == contact.phoneNumber  {
            phoneContacts[index].isFavourite = isFavourite
        }
        Storage.store(phoneContacts, to: .documents, as: "contacts.json")
        favouriteContacts.remove(at: indexPathTapped.row)
        Storage.store(favouriteContacts, to: .documents, as: "favouriteContacts.json")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    lazy var favouriteContacts = Storage.retrieve("favouriteContacts.json", from: .documents, as: [PhoneContact].self)

    func getContacts() -> [PhoneContact] {
        var favouriteContactsFromStorage = [PhoneContact]()
        if let data = UserDefaults.standard.object(forKey: "favouriteContacts") as? Data {
            if let favouriteContacts = try? PropertyListDecoder().decode([PhoneContact].self, from: data) {
                favouriteContactsFromStorage = favouriteContacts
            }
        }
        return favouriteContactsFromStorage
    }

    override func viewWillAppear(_ animated: Bool) {
        favouriteContacts = Storage.retrieve("favouriteContacts.json", from: .documents, as: [PhoneContact].self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FavouriteContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
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
        cell.selectionStyle = .none
        cell.heartButton.isSelected = true
        if favouriteContacts[indexPath.row].imageDataAvailable {
            guard let data = favouriteContacts[indexPath.row].avatarData else {
                fatalError("Error")
            }
            cell.cellProfileImageView.image = UIImage(data: data)
        } else {
            cell.cellProfileImageView.image = UIImage(systemName: "person.circle.fill")
        }
        cell.cellName.text = favouriteContacts[indexPath.row].name
        cell.cellPhoneNumber.text = favouriteContacts[indexPath.row].phoneNumber.first
        return cell
    }
}
