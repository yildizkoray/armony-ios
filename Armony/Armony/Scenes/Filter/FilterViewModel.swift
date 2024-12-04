//
//  FilterViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 08.06.23.
//

import Foundation

protocol FilterViewModelDelegate: AnyObject {
    func applyButtonTapped(filters: FilterViewModel.Filters)
}

final class FilterViewModel: ViewModel {

    struct Filter {
        let id: Int?
        let title: String?

        init(id: Int?, title: String?) {
            self.id = id
            self.title = title
        }

        static let empty = Filter(id: nil, title: nil)
    }
    
    struct Filters {
        var advert: Filter?
        var location: Filter?

        static let empty = Filters(advert: nil, location: nil)

        var isEmpty: Bool {
            return advert.isNil && location.isNil
        }
    }

    var filterDidUpdate: Callback<FilterViewModel.Filters>? = nil

    private weak var view: FilterViewDelegate?
    weak var delegate: FilterViewModelDelegate?
    var coordinator: FilterCoordinator!

    var filters: Filters = .empty {
        didSet {
            filterDidUpdate?(filters)
        }
    }

    init(view: FilterViewDelegate?, selectedFilters: Filters = .empty) {
        self.view = view
        self.filters = selectedFilters
    }

    func advertTypeDropdownTapped() {
        view?.startAdvertTypeDropdownViewActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(task: GetAdvertTypesTask(),
                                                         type: RestArrayResponse<Advert.Properties>.self)

                let items = response.itemsForSelection(selectedID: filters.advert?.id)
                let selectionPresentation = AdvertTypeSelectionPresentation(delegate: self, items: items)
                safeSync {
                    view?.stopAdvertTypeDropdownViewActivityIndicatorView()
                    SelectionBottomPopUpCoordinator(navigator: coordinator.navigator).start(presentation: selectionPresentation)
                }
            }
            catch {
                safeSync {
                    view?.stopAdvertTypeDropdownViewActivityIndicatorView()
                }
            }
        }
    }

    func locationDropdownTapped() {
        view?.startLocationDropdownViewActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(task: GetLocationTask(),
                                                         type: RestArrayResponse<Location>.self)

                let items = response.itemsForSelection(selectedID: filters.location?.id)
                let selectionPresentation = LocationSelectionPresentation(delegate: self, items: items)

                safeSync {
                    view?.stopLocationDropdownViewActivityIndicatorView()
                    SelectionBottomPopUpCoordinator(navigator: coordinator.navigator).start(presentation: selectionPresentation)
                }
            }
            catch {
                safeSync {
                    view?.stopLocationDropdownViewActivityIndicatorView()
                }
            }
        }
    }

    func applyButtonTapped() {
        coordinator.dismiss { [weak self] in
            self?.delegate?.applyButtonTapped(filters: self?.filters ?? .empty)
        }
    }
}

// MARK: - AdvertTypeSelectionDelegate
extension FilterViewModel: AdvertTypeSelectionDelegate {

    func advertTypeDidSelect(advert: SelectionInput?) {
        if let advert {
            filters.advert = Filter(id: advert.id, title: advert.title)
        }
        else {
            filters.advert = nil
        }
        view?.updateAdvertType(title: advert?.title)
    }
}

// MARK: - AdvertTypeSelectionDelegate
extension FilterViewModel: LocationSelectionDelegate {

    func locationDidSelect(location: SelectionInput?) {
        if let location {
            filters.location = Filter(id: location.id, title: location.title)
        }
        else {
            filters.location = nil
        }
        view?.updateLocation(title: location?.title)
    }
}

