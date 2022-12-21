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
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
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

    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let alert = UIAlertController(title: phoneContacts[indexPath.row].name, message: "Please select an option", preferredStyle: .alert)

                let copyActionButton = UIAlertAction(title: "Copy", style: .default) { [self] _ in
                    copyPhoneNumber(index: indexPath.row)
                }
                alert.addAction(copyActionButton)
                copyActionButton.setValue(UIImage(systemName: "doc.on.doc"), forKey: "image")
                copyActionButton.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

                let shareActionButton = UIAlertAction(title: "Share", style: .default) { [self]_ in
                    shareWithPhoneNumber(index: indexPath.row)
                }
                alert.addAction(shareActionButton)
                shareActionButton.setValue(UIImage(systemName: "square.and.arrow.up"), forKey: "image")
                shareActionButton.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

                let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelActionButton)
                cancelActionButton.setValue(UIImage(systemName: "arrowshape.turn.up.backward"), forKey: "image")
                cancelActionButton.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

                let deleteActionButton = UIAlertAction(title: "Delete", style: .destructive) { [self]_ in
                    removeContact(indexPath: indexPath)
                }
                alert.addAction(deleteActionButton)
                deleteActionButton.setValue(UIImage(systemName: "trash"), forKey: "image")
                deleteActionButton.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

                alert.view.tintColor = UIColor(named: "TextColor")
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    private func copyPhoneNumber(index: Int) {
        UIPasteboard.general.string = phoneContacts[index].phoneNumber.first
    }

    private func shareWithPhoneNumber(index: Int) {
        let phoneNumberToShare = [phoneContacts[index].phoneNumber.first]
        let activityViewController = UIActivityViewController(activityItems: phoneNumberToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

        self.present(activityViewController, animated: true, completion: nil)
    }

    private func removeContact(indexPath: IndexPath) {
        phoneContacts.remove(at: indexPath.row)
        Storage.store(phoneContacts, to: .documents, as: "contacts.json")
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeContact(indexPath: indexPath)
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
