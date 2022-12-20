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
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false
    var isFavourite = false

    init(contact: CNContact) {
        name = contact.givenName + " " + contact.familyName
        avatarData = contact.imageData
        imageDataAvailable = contact.imageDataAvailable
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
}
