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

enum GetContactsError: Error {
    case errorFetchingContainers
    case errorInGettingKeyDescriptor
}

final class PhoneContacts {
    func getContacts(filter: ContactsFilter = .none) throws -> [CNContact] {
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactImageDataKey, CNContactImageDataAvailableKey] as [Any]

        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            throw GetContactsError.errorFetchingContainers
        }

        var results: [CNContact] = []

        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                guard let keysToFetch = keysToFetch as? [CNKeyDescriptor] else {
                    throw GetContactsError.errorInGettingKeyDescriptor
                }
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch)
                results.append(contentsOf: containerResults)
            } catch {
                throw GetContactsError.errorFetchingContainers
            }
        }
        return results
    }
}
