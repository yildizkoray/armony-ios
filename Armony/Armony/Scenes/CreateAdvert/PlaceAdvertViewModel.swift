//
//  PlaceAdvertViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 05.10.22.
//

import Foundation

final class PlaceAdvertViewModel: ViewModel {

    // MARK: - Storage
    private struct SelectedIDStorage {
        var advert: Int? {
            didSet {
                if  advert != oldValue {
                    resetSkills()
                }
            }
        }
        var location: Int?
        var musicGenres: [Int]
        var skills: [Int]
        var services: [Int]

        private mutating func resetSkills() {
            skills = .empty
        }

        // MARK: - EMPTY
        static let empty = SelectedIDStorage(
            advert: nil,
            location: nil,
            musicGenres: .empty,
            skills: .empty,
            services: .empty
        )
    }

    var coordinator: PlaceAdvertCoordinator!
    private weak var view: PlaceAdvertViewDelegate?
    private let notificationService: PlaceAdvertNotificationService = .shared
    private let authenticator: AuthenticationService = .shared

    private var selectedIDStorage: SelectedIDStorage = .empty
    private var request: PlaceAdvertRequest
    private var advertsResponse: [Advert.Properties] = .empty
    private(set) var hasUserAdverts: Bool = false
    private(set) var userAdsCountRequestError: Error?
    private var description: String? = nil {
        didSet {
            self.request.description = description.isNotNilOrEmpty ? description : nil
        }
    }

    init(view: PlaceAdvertViewDelegate) {
        self.view = view
        self.request = .empty
        super.init()
    }

    func descriptionTextViewDidChange(description: String?) {
        self.description = description
    }

    func resetInputs() {
        selectedIDStorage = .empty
        description = .empty
        request = .empty

        view?.updateMusicGenres(title: nil)
        view?.updateAdvertType(title: nil)
        view?.updateSkills(title: nil)
        view?.updateLocation(title: nil)
        view?.updateInstructionType(title: nil)
        view?.setInformationsStackViewVisibility(isHidden: selectedIDStorage.advert.isNil)

        view?.resetTextView()
    }

    func advertTypeDropdownTapped() {
        view?.startAdvertTypeDropdownViewActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(task: GetAdvertTypesTask(),
                                                         type: RestArrayResponse<Advert.Properties>.self)

                self.advertsResponse = response.data

                let items = response.itemsForSelection(selectedID: selectedIDStorage.advert)
                let selectionPresentation = AdvertTypeSelectionPresentation(delegate: self, items: items)
                safeSync {
                    view?.stopAdvertTypeDropdownViewActivityIndicatorView()
                    coordinator.profileSelection(presentation: selectionPresentation)
                }
            }
            catch {
                safeSync {
                    view?.stopAdvertTypeDropdownViewActivityIndicatorView()
                }
            }
        }
    }

    func musicGenresDropdownTapped() {

        view?.startMusicGenresDropdownViewActivityIndicatorView()

        Task {
            do {
                let response = try await service.execute(task: GetMusicGenresTask(),
                                                         type: RestArrayResponse<MusicGenre>.self)

                let items = response.itemsForSelection(selectedIDs: selectedIDStorage.musicGenres)
                let selectionPresentation = MusicGenresSelectionPresentation(delegate: self, items: items)

                safeSync {
                    view?.stopMusicGenresDropdownViewActivityIndicatorView()
                    coordinator.profileSelection(presentation: selectionPresentation)
                }
            }
            catch {
                safeSync {
                    view?.stopMusicGenresDropdownViewActivityIndicatorView()
                }
            }
        }
    }

    func skillsDropdownTapped() {
        view?.startSkillsDropdownViewActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(task: GetSkillsTask(for: selectedIDStorage.advert.ifNil(.zero)),
                                                         type: RestArrayResponse<Skill>.self)

                let items = response.itemsForSelection(selectedIDs: selectedIDStorage.skills)
                let selectionPresentation = SkillsSelectionPresentation(delegate: self,
                                                                        items: items,
                                                                        headerTitle: .empty)

                safeSync {
                    view?.stopSkillsDropdownViewActivityIndicatorView()
                    coordinator.profileSelection(presentation: selectionPresentation)
                }
            }
            catch {
                safeSync {
                    view?.stopSkillsDropdownViewActivityIndicatorView()
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

                let items = response.itemsForSelection(selectedID: selectedIDStorage.location)
                let selectionPresentation = LocationSelectionPresentation(delegate: self, items: items)

                safeSync {
                    view?.stopLocationDropdownViewActivityIndicatorView()
                    coordinator.profileSelection(presentation: selectionPresentation)
                }
            }
            catch {
                safeSync {
                    view?.stopLocationDropdownViewActivityIndicatorView()
                }
            }
        }
    }

    func instructionTypeDropdownView() {
        view?.startInstructionTypeDropdownViewActivityIndicatorView()
        guard let selectedAdvertID = selectedIDStorage.advert else {
            return
        }
        Task {
            do {
                let response = try await service.execute(task: GetServicesTask(adTypeID: selectedAdvertID),
                                                         type: RestArrayResponse<ServiceResponse>.self)

                let items = response.itemsForSelection(selectedIDs: selectedIDStorage.services)
                let selectionPresentation = ServiceSelectionPresentation(delegate: self, items: items)

                safeSync {
                    view?.stopInstructionTypeDropdownViewActivityIndicatorView()
                    coordinator.profileSelection(presentation: selectionPresentation)
                }
            }
            catch {
                safeSync {
                    view?.stopInstructionTypeDropdownViewActivityIndicatorView()
                }
            }
        }
    }


    func submitButtonTapped() {
        view?.startSubmitButtonActivityIndicatorView()

        Task { @MainActor in
            do {
                let hasUserAds = try await hasUserAds()
                view?.stopSubmitButtonActivityIndicatorView()
                if hasUserAds, RevenueCatPurchaseStorageService.shared.identifiers.isEmpty {
                    view?.showPaywall()
                }
                else {
                    createAd(transactionID: nil)
                }
            }
            catch let error {
                view?.stopSubmitButtonActivityIndicatorView()
                AlertService.show(message: error.api.ifNil(.network).description, actions: [.okay()])
            }
        }
    }


    func createAd(transactionID: String?) {
        view?.startSubmitButtonActivityIndicatorView()
        Task { @MainActor in
            do {
                let response = try await service.execute(task: PostPlaceAdvertTask(request: request),
                                                         type: RestObjectResponse<Advert>.self)

                PlaceAdvertAdjustEventsHandler.track(for: request.advertTypeID)

                let adTitle = advertsResponse.first { $0.id == request.advertTypeID }?.title

                PlaceAdvertFirebaseEvents(
                    label: adTitle.emptyIfNil,
                    parameters: request.eventParameters()
                ).send()

                view?.stopSubmitButtonActivityIndicatorView()
                resetInputs()

                let view = coordinator.selectTab(tab: .account, shouldPopToRoot: true)

                if let view = view as? AccountViewController {
                    view.viewModel.currentSelectedSegmentIndex = 1
                    if view.isViewLoaded {
                        view.selectSegment(at: 1)
                    }
                }
                NotificationCenter.default.post(
                    notification: .newAdvertDidPlace,
                    userInfo: [.advert: response.data]
                )

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    AppRatingService.shared.requestReviewIfNeeded()
                }

                if let transactionID {
                    RevenueCatPurchaseStorageService.shared.remove(transactionID: transactionID)
                }
            }
            catch let error {
                view?.stopSubmitButtonActivityIndicatorView()
                AlertService.show(message: error.api.ifNil(.network).description, actions: [.okay()])
            }
        }
    }

    func hasUserAds() async throws -> Bool {
        let response = try await service.execute(
            task: GetUserAdvertsTask(userID: authenticator.userID),
            type: RestArrayResponse<Advert>.self
        )
        return !response.data.isEmpty
    }
}

// MARK: - AdvertTypeSelectionDelegate
extension PlaceAdvertViewModel: AdvertTypeSelectionDelegate {

    func advertTypeDidSelect(advert: SelectionInput?) {
        selectedIDStorage = .empty
        request = .empty
        if selectedIDStorage.advert != advert?.id {
            view?.updateSkills(title: .empty)
            request.skills = .empty
        }

        view?.updateSkills(title: nil)
        view?.updateLocation(title: nil)
        view?.updateMusicGenres(title: nil)
        view?.updateInstructionType(title: nil)

        view?.setInformationsStackViewVisibility(isHidden: advert.isNil)
        if let advert {
            selectedIDStorage.advert = advert.id
            view?.updateAdvertType(title: advert.title)
            request.advertTypeID = advert.id

            if advert.id == 1 {
                view?.configureMusicGenreDropdownView(presentation: .musicGenres)
                view?.configureSkillDropdownView(presentation: .skill)
                view?.setMusicGenresDropdownViewVisibility(isHidden: false)
                view?.setInstructionTypeDropdownViewVisibility(isHidden: true)
                view?.updateValidators(validator: .musician)

            } else if [3,5].contains(advert.id) {
                view?.updateValidators(validator: .event)
                view?.setMusicGenresDropdownViewVisibility(isHidden: true)
                view?.configureSkillDropdownView(presentation: .services)
                view?.setInstructionTypeDropdownViewVisibility(isHidden: true)
            }
            else if advert.id == 4 {
                view?.updateValidators(validator: .instructor)
                view?.configureSkillDropdownView(presentation: .instruction)
                view?.setInstructionTypeDropdownViewVisibility(isHidden: false)
                view?.setMusicGenresDropdownViewVisibility(isHidden: true)
            }
            else {
                view?.updateValidators(validator: .brand)
                view?.setMusicGenresDropdownViewVisibility(isHidden: false)
                view?.setInstructionTypeDropdownViewVisibility(isHidden: true)
                view?.configureSkillDropdownView(presentation: .skill)
                view?.configureMusicGenreDropdownView(presentation: .musicGenres)
            }
        }
    }
}

// MARK: - LocationSelectionDelegate
extension PlaceAdvertViewModel: LocationSelectionDelegate {

    func locationDidSelect(location: SelectionInput?) {
        selectedIDStorage.location = location?.id
        view?.updateLocation(title: location?.title)
        request.location = location.map { selectedLocation in
            return Location(id: selectedLocation.id, title: selectedLocation.title)
        }
    }
}

// MARK: - SkillsSelectionDelegate
extension PlaceAdvertViewModel: SkillsSelectionDelegate {

    func skillsDidSelect(skills: [SelectionInput]?) {
        selectedIDStorage.skills = skills.ifNil(.empty).compactMap { $0.id }
        view?.updateSkills(title: skills?.title)

        request.skills = skills?.compactMap { skill in
            return Skill(id: skill.id, iconURL: nil, title: skill.title, colorCode: nil)
        }
    }
}

// MARK: - MusicGenresSelectionDelegate
extension PlaceAdvertViewModel: MusicGenresSelectionDelegate {

    func musicGenresDidSelect(genres: [SelectionInput]?) {
        selectedIDStorage.musicGenres = genres.ifNil(.empty).compactMap { $0.id }
        view?.updateMusicGenres(title: genres?.title)

        request.genres = genres?.compactMap { genre in
            return MusicGenre(id: genre.id, name: genre.title)
        }
    }
}

// MARK: - ServiceSelectionDelegate
extension PlaceAdvertViewModel: ServiceSelectionDelegate {

    func serviceDidSelect(services: [any SelectionInput]?) {
        selectedIDStorage.services = services.ifNil(.empty).compactMap { $0.id }
        view?.updateInstructionType(title: services?.title)

        request.serviceTypes = services?.compactMap { service in
            return ServiceResponse(id: service.id, title: service.title)
        }
    }
}
