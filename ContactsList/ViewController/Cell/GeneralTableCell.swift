//
//  GeneralTableCell.swift
//  ContactsList
//
//  Created by Pavel on 20.12.22.
//

import UIKit

class GeneralTableCell: UITableViewCell {
    lazy var cellProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var cellName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "MarkPro-Bold", size: 18)
        label.textColor = UIColor(named: "TextColor")
        label.numberOfLines = 0
        return label
    }()

    lazy var cellPhoneNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "WorkSans-Regular", size: 16)
        label.textColor = UIColor(named: "PhoneNumberColor")
        label.numberOfLines = 0
        return label
    }()

    lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cellName, cellPhoneNumber])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "generalTableCell")
        accessoryView = heartButton
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.addSubview(cellProfileImageView)
        self.addSubview(stackView)
    }

    private func makeConstraints() {
        cellProfileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
            $0.leading.equalTo(contentView).offset(20)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leftMargin.equalToSuperview().offset(10)
            $0.rightMargin.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(cellProfileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
        }
    }
}
