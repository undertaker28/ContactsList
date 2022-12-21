//
//  ContactsViewController.swift
//  ContactsList
//
//  Created by Pavel on 19.12.22.
//

import UIKit
import SnapKit

final class ContactsViewController: UIViewController {
    var phoneContacts = Storage.retrieve("contacts.json", from: .documents, as: [PhoneContact].self) {
        didSet {
            if !phoneContacts.isEmpty {
                tableView.isHidden = false
            } else {
                tableView.isHidden = true
                loadContactsButton.isHidden = false
            }
        }
    }
    var favouriteContacts = [PhoneContact]()
    var filter: ContactsFilter = .none

    private lazy var loadContactsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Загрузить контакты", for: .normal)
        button.setTitleColor(UIColor(named: "TextColor"), for: .normal)
        button.backgroundColor = UIColor(named: "UIElementsColor")
        button.layer.cornerRadius = 34
        button.clipsToBounds = true
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.6
        button.layer.masksToBounds = false
        button.titleLabel?.font = UIFont(name: "WorkSans-Regular", size: 18)
        button.tag = 0
        button.addTarget(self, action: #selector(loadContacts), for: .touchUpInside)
        button.addPressAnimation()
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactsTableCell.self, forCellReuseIdentifier: "contactsTableCell")
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
        view.addSubview(loadContactsButton)
        loadContactsButton.isHidden = phoneContacts.isEmpty ? false : true
        //        Storage.store(phoneContacts, to: .documents, as: "contacts.json")
        //        Storage.store(phoneContacts, to: .documents, as: "favouriteContacts.json")
        setupNavigationBar()
        makeConstraints()
    }

    private func makeConstraints() {
        loadContactsButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(76)
            $0.width.equalTo(216)
        }

        tableView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Contacts"
    }

    @objc private func loadContacts() {
        loadContactsFromPhone(filter: filter)
        loadContactsButton.isHidden = true
        tableView.isHidden = false
    }

    func addToFavourite(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        let contact = phoneContacts[indexPathTapped.row]
        let isFavourite = !contact.isFavourite
        var favouriteContacts = Storage.retrieve("favouriteContacts.json", from: .documents, as: [PhoneContact].self)
        if isFavourite {
            favouriteContacts.append(contact)
        } else {
            for (index, favouriteContact) in favouriteContacts.enumerated() where favouriteContact.phoneNumber == contact.phoneNumber {
                favouriteContacts.remove(at: index)
            }
        }
        phoneContacts[indexPathTapped.row].isFavourite = isFavourite
        Storage.store(phoneContacts, to: .documents, as: "contacts.json")
        Storage.store(favouriteContacts, to: .documents, as: "favouriteContacts.json")
    }

    private func loadContactsFromPhone(filter: ContactsFilter) {
        phoneContacts.removeAll()
        var allContacts = [PhoneContact]()
        for contact in PhoneContacts().getContacts(filter: filter) {
            allContacts.append(PhoneContact(contact: contact))
        }
        phoneContacts.append(contentsOf: allContacts)

        Storage.store(phoneContacts, to: .documents, as: "contacts.json")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        phoneContacts = Storage.retrieve("contacts.json", from: .documents, as: [PhoneContact].self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            phoneContacts.remove(at: indexPath.row)
            Storage.store(phoneContacts, to: .documents, as: "contacts.json")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneContacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactsTableCell", for: indexPath) as? ContactsTableCell else {
            fatalError("Couldn't cast cell")
        }
        cell.link = self
        cell.backgroundColor = UIColor(named: "BackgroundColor")
        cell.selectionStyle = .none
        cell.heartButton.isSelected = phoneContacts[indexPath.row].isFavourite
        if phoneContacts[indexPath.row].imageDataAvailable {
            guard let data = phoneContacts[indexPath.row].avatarData else {
                fatalError("Error")
            }
            cell.cellProfileImageView.image = UIImage(data: data)
        } else {
            cell.cellProfileImageView.image = UIImage(systemName: "person.circle.fill")
        }
        cell.cellName.text = phoneContacts[indexPath.row].name
        cell.cellPhoneNumber.text = phoneContacts[indexPath.row].phoneNumber.first
        return cell
    }
}
