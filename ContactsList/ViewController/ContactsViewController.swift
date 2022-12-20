//
//  ContactsViewController.swift
//  ContactsList
//
//  Created by Pavel on 19.12.22.
//

import UIKit
import SnapKit

final class ContactsViewController: UIViewController {
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
        let tableView = UITableView()
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
        loadContacts1(filter: filter)
        loadContactsButton.isHidden = true
        tableView.isHidden = false
    }

    func addToFavourite(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        let contact = phoneContacts[indexPathTapped.row]
        print(contact)
        let isFavourite = contact.isFavourite
        phoneContacts[indexPathTapped.row].isFavourite = !isFavourite
    }

    var phoneContacts = [PhoneContact]() {
        didSet {
           if !phoneContacts.isEmpty {
               tableView.isHidden = false
           } else {
               tableView.isHidden = true
               loadContactsButton.isHidden = false
           }
        }
    }
    var filter: ContactsFilter = .none

    private func loadContacts1(filter: ContactsFilter) {
        phoneContacts.removeAll()
        var allContacts = [PhoneContact]()
        for contact in PhoneContacts().getContacts(filter: filter) {
            allContacts.append(PhoneContact(contact: contact))
        }
        phoneContacts.append(contentsOf: allContacts)

        for contact in phoneContacts {
            print("Name -> \(contact.name)")
            print("Email -> \(contact.email)")
            print("Phone Number -> \(contact.phoneNumber)")
        }
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
        if phoneContacts[indexPath.row].imageDataAvailable {
            guard let data = phoneContacts[indexPath.row].avatarData else {
                fatalError("Error")
            }
            cell.cellImageView.image = UIImage(data: data)
        } else {
            cell.cellImageView.image = UIImage(systemName: "person.circle.fill")
        }
        cell.cellTitle.text = phoneContacts[indexPath.row].name
        cell.cellDescription.text = phoneContacts[indexPath.row].phoneNumber.first
        return cell
    }
}
