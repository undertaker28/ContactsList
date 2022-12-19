//
//  PhoneContacts.swift
//  ContactsList
//
//  Created by Pavel on 20.12.22.
//

import ContactsUI

enum ContactsFilter {
    case none
    case mail
    case message
}

final class PhoneContacts {
    func getContacts(filter: ContactsFilter = .none) -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                guard let keysToFetch = keysToFetch as? [CNKeyDescriptor] else {
                    fatalError("Couldn't get key descriptor")
                }
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                results.append(contentsOf: containerResults)
            } catch {
                print("Error fetching containers")
            }
        }
        return results
    }
}
