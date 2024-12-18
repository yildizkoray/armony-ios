//
//  RegionsViewModel.swift
//  Armony
//
//  Created by KORAY YILDIZ on 17/12/2024.
//

import Foundation
import Combine

@available(iOS 16, *)
final class RegionsViewModel: ObservableObject {
    
    var coordinator: RegionsCoordinator!
    @Published var region: String = Defaults.shared[.region].emptyIfNil
    @Published var isActive: Bool = Defaults.shared[.isRegionActive]
    @Published var regions: [Region] = Locale.Region.isoRegions.map {
        let code = $0.identifier
        let name = countryName(from: code)
        return Region(code: code, name: name)
    }
    private var cancelables = Set<AnyCancellable>()
    
    
    init() {
        $region
            .sink { region in
                Defaults.shared[.region] = region
            }
            .store(in: &cancelables)
        
        $isActive
            .sink { isActive in
                Defaults.shared[.isRegionActive] = isActive
            }
            .store(in: &cancelables)
    }
    
    class func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return name
        } else {
            return countryCode
        }
    }
}
