//
//  Analytic.swift
//  Armony
//
//  Created by Koray Yıldız on 28.11.22.
//

import Foundation

protocol Sendable {
    func send()
}

protocol Analytic {
    associatedtype Event

    func send(event: Event)
}

protocol Event: Sendable { }



