//
//  ContactDetailViewController.swift
//  ContactsList
//
//  Created by Pavel on 22.12.22.
//

import UIKit

final class ContactDetailViewController: UIViewController {
    lazy var contactImage = UIImage()
    lazy var name = ""
    lazy var phoneNumber = ""
    lazy var index = 0

    private lazy var contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 52
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Bold", size: 30)
        label.textColor = UIColor(named: "TitleColor")
        label.numberOfLines = 0
        return label
    }()

    private lazy var textFieldName: UITextField = {
        let sampleTextField = UITextField()
        sampleTextField.text = name
        sampleTextField.font = UIFont(name: "WorkSans-Regular", size: 20)
        sampleTextField.isEnabled = false
        sampleTextField.setLeftIcon(UIImage(systemName: "person.circle"))
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return sampleTextField
    }()

    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "MarkPro-Bold", size: 30)
        label.textColor = UIColor(named: "TitleColor")
        label.numberOfLines = 0
        return label
    }()

    private lazy var textFieldPhoneNumber: UITextField = {
        let sampleTextField = UITextField()
        sampleTextField.text = phoneNumber
        sampleTextField.font = UIFont(name: "WorkSans-Regular", size: 20)
        sampleTextField.isEnabled = false
        sampleTextField.setLeftIcon(UIImage(systemName: "phone.circle"))
        sampleTextField.borderStyle = UITextField.BorderStyle.roundedRect
        sampleTextField.autocorrectionType = UITextAutocorrectionType.no
        sampleTextField.keyboardType = UIKeyboardType.default
        sampleTextField.returnKeyType = UIReturnKeyType.done
        sampleTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        sampleTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return sampleTextField
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, textFieldName, phoneNumberLabel, textFieldPhoneNumber])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        setupStackView()
        addSubviews()
        makeConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMode))
    }

    @objc private func editMode() {
        navigationItem.rightBarButtonItem?.title = navigationItem.rightBarButtonItem?.title == "Edit" ? "Save" : "Edit"
        if navigationItem.rightBarButtonItem?.title == "Save" {
            textFieldName.isEnabled = true
            textFieldPhoneNumber.isEnabled = true
        } else {
            if textFieldName.isEditing || textFieldPhoneNumber.isEditing {
                var contacts = Storage.retrieve("contacts.json", from: .documents, as: [PhoneContact].self)
                contacts[index].name = textFieldName.text
                contacts[index].phoneNumber = textFieldPhoneNumber.text ?? contacts[index].phoneNumber
                Storage.store(contacts, to: .documents, as: "contacts.json")
            }
            textFieldName.isEnabled = false
            textFieldPhoneNumber.isEnabled = false
        }
    }

    private func setupStackView() {
        contactImageView.image = contactImage
        nameLabel.text = "Name"
        phoneNumberLabel.text = "Phone number"
    }

    private func addSubviews() {
        view.addSubview(contactImageView)
        view.addSubview(stackView)
    }

    private func makeConstraints() {
        contactImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(104)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(contactImageView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}
