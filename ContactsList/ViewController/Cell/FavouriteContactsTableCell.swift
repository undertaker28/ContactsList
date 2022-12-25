//
//  FavouriteContactsTableCell.swift
//  ContactsList
//
//  Created by Pavel on 20.12.22.
//

import UIKit

final class FavouriteContactsTableCell: GeneralTableCell {
    var link: FavouriteContactsViewController?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "favouriteContactsTableCell")
        heartButton.addTarget(self, action: #selector(deleteFromFavourite), for: .touchUpInside)
    }

    @objc private func deleteFromFavourite(_ sender: UIButton) {
        sender.isSelected = sender.isSelected == true ? false : true
        link?.markAsNotFavorite(cell: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
