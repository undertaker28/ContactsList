//
//  ContactsTableCell.swift
//  ContactsList
//
//  Created by Pavel on 20.12.22.
//

import UIKit

final class ContactsTableCell: UITableViewCell {
    var link: ContactsViewController?

    lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var cellTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "MarkPro-Bold", size: 18)
        //label.textColor = UIColor(named: "TitleColor")
        label.numberOfLines = 0
        return label
    }()

    lazy var cellDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "WorkSans-Regular", size: 16)
        //label.textColor = UIColor(named: "DescriptionColor")
        label.numberOfLines = 0
        return label
    }()

    private lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.addTarget(self, action: #selector(addToFavourite), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cellTitle, cellDescription])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "contactsTableCell")
        accessoryView = heartButton
        addSubviews()
        makeConstraints()
    }

    @objc private func addToFavourite(_ sender: UIButton) {
        sender.isSelected = sender.isSelected == true ? false : true
        print("addToFavourite")
        link?.addToFavourite(cell: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.addSubview(cellImageView)
        self.addSubview(stackView)
    }

    private func makeConstraints() {
        cellImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
            $0.leading.equalTo(contentView).offset(20)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leftMargin.equalToSuperview().offset(10)
            $0.rightMargin.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(cellImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
        }
    }
}
