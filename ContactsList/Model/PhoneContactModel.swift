//
//  PhoneContactModel.swift
//  ContactsList
//
//  Created by Pavel on 20.12.22.
//

import ContactsUI

struct PhoneContact: Codable {
    var name: String?
    var avatarData: Data?
    var imageDataAvailable: Bool
    var phoneNumber: String
    var isFavourite = false

    init(contact: CNContact) {
        name = contact.givenName + " " + contact.familyName
        avatarData = contact.imageData
        imageDataAvailable = contact.imageDataAvailable
        phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
    }
}
