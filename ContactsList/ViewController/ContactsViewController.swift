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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        view.addSubview(loadContactsButton)
        makeConstraints()
    }

    private func makeConstraints() {
        loadContactsButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.equalTo(76)
            $0.width.equalTo(216)
        }
    }

    @objc private func loadContacts() {
        print("test")
    }
}
