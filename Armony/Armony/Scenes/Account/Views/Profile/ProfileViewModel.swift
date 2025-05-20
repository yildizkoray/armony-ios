//
//  ProfileViewModel.swift
//  Armony
//
//  Created by Koray Yildiz on 31.05.22.
//

import Foundation

protocol ProfileViewModelDelegate: AnyObject {
    func didUpdateUserProfile()
}

final class ProfileViewModel: ViewModel {

    var coordinator: ProfileCoordinator!

    private weak var view: ProfileViewDelegate?
    private weak var delegate: ProfileViewModelDelegate?

    private let authenticator: AuthenticationService = .shared

    private var presentation: ProfilePresentation

    private var request: PutProfileUpdateRequest
    private var selectedItemIDs: [Int] = .empty

    private let isEmptyUser: Bool

    init(view: ProfileViewDelegate,
         presentation: ProfilePresentation,
         delegate: ProfileViewModelDelegate?) {
        self.view = view
        self.presentation = presentation
        self.isEmptyUser = presentation.isEmpty()
        self.delegate = delegate
        self.request = presentation.createProfileUpdateRequest()
        super.init()
    }

    func textViewDidEndEditing(text: String) {
        request.bio = text
    }

    func saveButtonDidTap() {
        view?.startSaveButtonActivityIndicatorView()
        let profileTask = PutProfileTask(userID: authenticator.userID, request: request)

        if isEmptyUser {
            CreateProfileFirebaseEvent(parameters: presentation.eventParameters()).send()
        }
        let musicGenreDiff = presentation.musicGenres?.difference(from: request.genres.ifNil(.empty))
        let skillsDiff = presentation.skills?.difference(from: request.skills.ifNil(.empty))

        if presentation.title?.id != request.title?.id ||
            !musicGenreDiff.ifNil(.empty).isEmpty ||
            !skillsDiff.ifNil(.empty).isEmpty ||
            presentation.location?.id != request.location?.id {
            EditProfileFirebaseEvent(parameters: request.eventParameters()).send()
        }

        if let avatarImageData = view?.newAvatarImageData {

            let formData = FormData(data: avatarImageData, key: "file", type: .jpg)
            let avatarTask = PutAvatarUpdateTask(userID: authenticator.userID, file: formData)

            Task {
                async let avatar = service.upload(
                    task: avatarTask,
                    type: RestObjectResponse<EmptyResponse>.self
                )
                async let profile = service.execute(
                    task: profileTask,
                    type: RestObjectResponse<EmptyResponse>.self
                )

                do {
                    let _ = try await (avatar, profile)
                    handleUpdateProfileTask()
                    sendCreateProfileEvent()
                }
                catch let error {
                    safeSync {
                        view?.stopSaveButtonActivityIndicatorView()
                    }
                    error.showAlert()
                }
            }
        }
        else {
            Task {
                do {
                    let _  = try await service.execute(
                        task: profileTask,
                        type: RestObjectResponse<EmptyResponse>.self
                    )
                    handleUpdateProfileTask()
                    sendCreateProfileEvent()
                }
                catch {
                    safeSync {
                        view?.stopSaveButtonActivityIndicatorView()
                    }
                    error.showAlert()
                }
            }
        }
    }

    fileprivate func sendCreateProfileEvent() {
        if let location = request.location,
           let title = request.title,
           let skills = request.skills, !skills.isEmpty,
           let genres = request.genres, !genres.isEmpty {
            let additionalParams: [String: String] = [
                "profile_type": title.title,
                "instrument_played": skills.map { $0.title }.joined(separator: .comma),
                "music_style": genres.map { $0.name }.joined(separator: .comma),
                "location": location.title,
                "explanation": request.bio ?? .empty
            ]
            CreateProfileFirebaseEvent(parameters: additionalParams).send()
            CreateProfileAdjustEvent().send()
        }
    }

    private func handleUpdateProfileTask() {
        safeSync {
            view?.stopSaveButtonActivityIndicatorView()
            delegate?.didUpdateUserProfile()
        }
        let message = String(localized: "Profile.Update.Alert.Success.Title", table: "Account+Localizable")
        AlertService.show(message: message, actions: [.okay(action: {
            self.coordinator.pop()
        })])
    }

    func titleDropdownDidTap() {
        view?.startTitleDropdownViewActivityIndicatorView()
        if let title = presentation.title {
            selectedItemIDs.append(title.id)
        }
        
        Task {
            do {
                let response  = try await service.execute(
                    task: GetTitlesTask(),
                    type: RestArrayResponse<UserDetail.Title>.self
                )
                safeSync {
                    view?.stopTitleDropdownViewActivityIndicatorView()
                    let items: [TitleSelectionInput] = response.data.compactMap { title in
                        return TitleSelectionInput(
                            id: title.id,
                            title: title.title,
                            isSelected: selectedItemIDs.contains(title.id)
                        )
                    }
                    let selectionPresentation = TitleSelectionPresentation(delegate: self, items: items)
                    coordinator.profileSelection(presentation: selectionPresentation)
                    selectedItemIDs = .empty
                }
            }
            catch {
                error.showAlert()
            }
        }
    }

    func skillsDropdownDidTap() {
        view?.startSkillsDropdownViewActivityIndicatorView()
        if let skills = presentation.skills {
            selectedItemIDs = skills.map { $0.id }
        }
        
        Task {
            do {
                let response  = try await service.execute(
                    task: GetSkillsTask(for: 1),
                    type: RestArrayResponse<Skill>.self
                )
                safeSync {
                    view?.stopSkillsDropdownViewActivityIndicatorView()
                    let items: [SkillsSelectionInput] = response.data.compactMap { skill in
                        return SkillsSelectionInput(
                            id: skill.id,
                            title: skill.title,
                            isSelected: selectedItemIDs.contains(skill.id)
                        )
                    }
                    let selectionPresentation = SkillsSelectionPresentation(delegate: self, items: items)
                    coordinator.profileSelection(presentation: selectionPresentation)
                    selectedItemIDs = .empty
                }
            }
            catch {
                error.showAlert()
            }
        }
    }

    func locationDropdownDidTap() {
        view?.startLocationDropdownViewActivityIndicatorView()
        if let location = presentation.location {
            selectedItemIDs.append(location.id)
        }
        
        Task {
            do {
                let response  = try await service.execute(
                    task: GetLocationTask(),
                    type: RestArrayResponse<Location>.self
                )
                safeSync {
                    view?.stopLocationDropdownViewActivityIndicatorView()
                    let items: [LocationSelectionInput] = response.data.compactMap { location in
                        return LocationSelectionInput(
                            id: location.id,
                            title: location.title,
                            isSelected: selectedItemIDs.contains(location.id)
                        )
                    }
                    let selectionPresentation = LocationSelectionPresentation(delegate: self, items: items)
                    coordinator.profileSelection(presentation: selectionPresentation)
                    selectedItemIDs = .empty
                }
            }
            catch {
                error.showAlert()
            }
        }
    }

    func musicGenresDropdownDidTap() {
        view?.startMusicGenresDropdownViewActivityIndicatorView()
        if let musicGenres = presentation.musicGenres {
            selectedItemIDs = musicGenres.map { $0.id }
        }
        
        Task {
            do {
                let response  = try await service.execute(
                    task: GetMusicGenresTask(),
                    type: RestArrayResponse<MusicGenre>.self
                )
                safeSync {
                    view?.stopMusicGenresDropdownViewActivityIndicatorView()
                    let items: [MusicGenresSelectionInput] = response.data.compactMap { musicGenre in
                        return MusicGenresSelectionInput(
                            id: musicGenre.id,
                            title: musicGenre.name,
                            isSelected: selectedItemIDs.contains(musicGenre.id)
                        )
                    }
                    let selectionPresentation = MusicGenresSelectionPresentation(delegate: self, items: items)
                    coordinator.profileSelection(presentation: selectionPresentation)
                    selectedItemIDs = .empty
                }
            }
            catch {
                error.showAlert()
            }
        }
    }
}

// MARK: - ViewModelLifeCycle
extension ProfileViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.configureUI()

        let avatarPresentation = AvatarPresentation(
            kind: .custom(.init(size: .medium, radius: .medium)),
            source: .url(presentation.avatarURLString?.url)
        )
        view?.configureAvatarView(with: avatarPresentation)
        view?.configureTitleDropdownView(with: .title)
        view?.configureSkillsDropdownView(with: .skill)
        view?.configureMusicGenresDropdownView(with: .musicGenres)
        view?.configureLocationDropdownView(with: .location)
        view?.configureBioTextView(with: .profile)

        view?.updateTitle(title: presentation.title?.title)

        let musicGenresTitle: String? = presentation.musicGenres?.compactMap { $0.name }.joined(separator: .comma + .space)
        view?.updateMusicGenres(title: musicGenresTitle)

        let skillsTitle: String? = presentation.skills?.compactMap { $0.title }.joined(separator: .comma + .space)
        view?.updateSkills(title: skillsTitle)

        view?.updateLocation(title: presentation.location?.title)
        view?.updateBioTextView(bio: presentation.bio.emptyIfNil)
    }
}

// MARK: ProfilePresentation | ProfileUpdateRequest
fileprivate extension ProfilePresentation {
    func createProfileUpdateRequest() -> PutProfileUpdateRequest {
        return PutProfileUpdateRequest(
            bio: bio,
            city: location,
            genres: musicGenres,
            title: title,
            skills: skills
        )
    }
}

// MARK: - TextViewPresentation
fileprivate extension TextViewPresentation {
    static var profile: TextViewPresentation {
        return TextViewPresentation(
            placeholder: String(localized: "Profile.TextView.Placeholder", table: "Account+Localizable"),
            numberOfMinimumChar: .zero,
            numberOfMaximumChar: 250
        )
    }
}

// MARK: - TitleSelectionDelegate
extension ProfileViewModel: TitleSelectionDelegate {
    func titleDidSelect(title: SelectionInput?) {
        if let title = title {
            let title = UserDetail.Title(id: title.id, title: title.title)
            request.title = title
        }
        else {
            presentation.title = nil
            request.title = nil
        }
        view?.updateTitle(title: title?.title)
    }
}

// MARK: - SkillsSelectionDelegate
extension ProfileViewModel: SkillsSelectionDelegate {
    func skillsDidSelect(skills: [SelectionInput]?) {
        let selectedSkills: [Skill]? = skills?.compactMap { item in
            return Skill(id: item.id,
                         iconURL: nil,
                         title: item.title,
                         colorCode: nil)
        }
        request.skills = selectedSkills
        view?.updateSkills(title: skills?.title)
    }
}

// MARK: - MusicGenresSelectionDelegate
extension ProfileViewModel: MusicGenresSelectionDelegate {
    func musicGenresDidSelect(genres: [SelectionInput]?) {
        let musicGenres: [MusicGenre]? = genres?.compactMap { item in
            return MusicGenre(id: item.id, name: item.title)
        }
        request.genres = musicGenres
        view?.updateMusicGenres(title: genres?.title)
    }
}

// MARK: - LocationSelectionDelegate
extension ProfileViewModel: LocationSelectionDelegate {
    func locationDidSelect(location: SelectionInput?) {
        if let location = location {
            let location = Location(id: location.id, title: location.title)
            request.location = location
            presentation.location = location
        }
        else {
            request.location = nil
        }
        view?.updateLocation(title: location?.title)
    }
}

// MARK: - Events

struct CreateProfileAdjustEvent: AdjustEvent {
    var token: String = "9dk2wl"
}

struct CreateProfileFirebaseEvent: FirebaseEvent {
    var category: String = "Profile"
    var name: String = "create_profile"
    var action: String = "Create"
    var parameters: Payload
}

struct EditProfileFirebaseEvent: FirebaseEvent {
    var category: String = "Profile"
    var name: String = "edit_profile"
    var action: String = "Edit"
    var parameters: Payload
}
