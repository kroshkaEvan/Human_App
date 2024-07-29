//
//  Cancelable.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import Combine

final class Cancelable {

    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    func store(in subscriber: Cancelable) {
        subscriber.subscriptions.insert(self)
    }
}
