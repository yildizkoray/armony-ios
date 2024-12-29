//
//  Region.swift
//  Armony
//
//  Created by KORAY YILDIZ on 17/12/2024.
//

import Foundation

struct Region: Identifiable, Hashable {
    let id = UUID()
    let code: String
    let name: String
    
    var displayName: String {
        return code + " - " + name
    }
}
