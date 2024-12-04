//
//  ViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 28.08.2021.
//

import Foundation

class ViewModel {

    let service: RestService

    init(service: RestService = RestService(backend: .factory())) {
        self.service = service
    }
}
