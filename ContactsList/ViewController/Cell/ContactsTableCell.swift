//
//  ContactsTableCell.swift
//  ContactsList
//
//  Created by Pavel on 20.12.22.
//

import UIKit

final class ContactsTableCell: GeneralTableCell {
    var link: ContactsViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "contactsTableCell")
        heartButton.addTarget(self, action: #selector(addToFavourite), for: .touchUpInside)
    }

    @objc private func addToFavourite(_ sender: UIButton) {
        sender.isSelected = sender.isSelected == true ? false : true
        print("addToFavourite")
        link?.addToFavourite(cell: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
