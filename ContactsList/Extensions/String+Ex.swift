//
//  String+Ex.swift
//  ContactsList
//
//  Created by Pavel on 24.12.22.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: "", comment: "")
    }
}
