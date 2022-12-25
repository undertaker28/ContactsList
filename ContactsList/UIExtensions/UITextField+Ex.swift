//
//  UITextField+Ex.swift
//  ContactsList
//
//  Created by Pavel on 22.12.22.
//

import UIKit

extension UITextField {
    func setLeftIcon(_ icon: UIImage!) {
        let padding = 7
        let size = 20

        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)

        leftView = outerView
        leftViewMode = .always
    }
}
