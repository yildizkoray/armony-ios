//
//  AdvertViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 23.11.2021.
//

import Foundation

final class AdvertViewModel: ViewModel {

    var coordinator: AdvertCoordinator!
    private let id: Int
    private weak var view: AdvertViewDelegate?
    private var isRemovingActive: Bool = false
    private let authenticator: AuthenticationService = .shared

    private(set) var dismissCompletion: Callback<Bool>? = nil
    private var isPreviousPageLiveChat: Bool = false

    private(set) var advert: Advert? = nil
    var shouldInfoViewIsShown: Bool {
        let isOwner = (advert?.user.id == authenticator.userID)
        return isOwner && (advert?.status == .autoInactive)
    }
    private var colorCode: String

    init(view: AdvertViewDelegate, id: Int,
         colorCode: String = .empty,
         isRemovingActive: Bool = false,
         isPreviousPageLiveChat: Bool,
         dismissCompletion: Callback<Bool>? = nil) {
        self.view = view
        self.id = id
        self.colorCode = colorCode
        self.isRemovingActive = isRemovingActive
        self.isPreviousPageLiveChat = isPreviousPageLiveChat
        self.dismissCompletion = dismissCompletion
        super.init()
    }

    func removeAdvertsButtonDidTap() {
        view?.startDeleteButtonActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(
                    task: GetFeedbackSubjectsTask(with: .removeAdvert),
                    type: RestArrayResponse<FeedbackSubject>.self
                )

                let items: [DeleteAdvertFeedbackSelectionInput] = response.data.map { subject in
                    return DeleteAdvertFeedbackSelectionInput(
                        id: subject.id, isSelected: false, title: subject.title
                    )
                }
                
                let selectionPresentation = DeleteAdvertFeedbackSelection(items: items, delegate: self)

                safeSync {
                    view?.stopDeleteButtonActivityIndicatorView()
                    coordinator.selectionBottomPopUp(presentation: selectionPresentation)
                }
            }
            catch let error {
                error.showAlert()
                safeSync {
                    view?.stopDeleteButtonActivityIndicatorView()
                }
            }
        }
    }

    func remove(feedback: FeedbackRequest) {
        view?.startDeleteButtonActivityIndicatorView()
        let firebaseEventParameters: [String:String] = [
            "reason": feedback.feedbackSubject.title
        ]

        Task {
            do {
                let _ = try await service.execute(
                    task: PostFeedbackTask(request: feedback),
                    type: RestObjectResponse<EmptyResponse>.self
                )
                let _ = try await service.execute(
                    task: DeleteUserAdvertTask(userID: AuthenticationService.shared.userID, advertID: id),
                    type: RestObjectResponse<EmptyResponse>.self
                )

                safeSync {
                    DeleteAdvertFirebaseEvent(
                        label: advert!.type.title,
                        parameters: firebaseEventParameters
                    ).send()
                    AdjustRemoveCardEvent().send()
                    view?.stopDeleteButtonActivityIndicatorView()
                    coordinator.dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }
                        NotificationCenter.default.post(notification: .advertDidRemove, userInfo: [.advertID: self.id])
                        self.dismissCompletion?(false)
                    }
                }
            }
            catch let error {
                error.showAlert()
                safeSync {
                    view?.startDeleteButtonActivityIndicatorView()
                }
            }
        }
    }

    func nameDidTap() {
        if let advert = advert {
            coordinator.visitedAccount(with: advert.user.id)
        }
    }

    func sendMessageButtonTapped() {
        if let externalLink = advert?.externalLink {
            ZuhalAcademyActionAdjustEvent().send()
            ZuhalAcademyActionFirebaseEvent().send()
            coordinator.openAtSafariViewController(url: externalLink)
        }
        else {
            handleSendMessage()
        }
    }

    private func handleSendMessage() {
        if !authenticator.isAuthenticated {

            MixPanelClickEvent(parameters: [
                "screen": "Advert",
                "advertID": id.string,
                "buttonType": "Send Message",
                "isAuthenticated": "false"
            ]).send()

            coordinator.registration { [weak self] in
                self?.apply()
            } didLogin: { [weak self] in
                let isOwner = (self?.advert?.user.id == self?.authenticator.userID)
                if isOwner {
                    AlertService.show(message: "Kendi oluşturduğunuz ilana mesaj gönderemezsiniz.",
                                      actions: [.okay(action: { [weak self] in
                        self?.view?.setApplyButtonButtonVisibility(isHidden: isOwner)
                        self?.view?.setRemoveAdvertsButtonVisibility(isHidden: !isOwner)

                    })])
                }
                else {
                    self?.apply()
                }
            }

        }
        else {

            MixPanelClickEvent(parameters: [
                "screen": "Advert",
                "advertID": id.string,
                "buttonType": "Send Message",
                "isAuthenticated": "true"
            ]).send()
            apply()
        }
    }

    private func apply() {
        guard !isPreviousPageLiveChat else {
            coordinator.dismiss()
            return
        }
        view?.startSendMessageButtonActivityIndicatorView()
        Task {
            do {
                let request = CreateLiveChatRequest(advertID: id)
                let response = try await service.execute(
                    task: PostCreateLiveChatTask(userID: authenticator.userID, request: request),
                    type: RestObjectResponse<CreateLiveChatResponse>.self
                )

                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                    coordinator.liveChat(with: response.data.chatID)
                }
            }
            catch let error {
                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    func blockUser() {
        view?.startSendMessageButtonActivityIndicatorView()
        Task {
            do {
                guard let advert = advert else { return }

                let request = PostBlockUserRequest(blockedUserId: advert.user.id)

                let _ = try await service.execute(
                    task: PostBlockUserTask(userID: authenticator.userID, request: request),
                    type: RestObjectResponse<EmptyResponse>.self
                )

                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                    coordinator.dismiss { [weak self] in
                        self?.dismissCompletion?(true)
                    }
                }
            }
            catch let error {
                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    func reportActionDidTap() {
        view?.startSendMessageButtonActivityIndicatorView()
        view?.startUserSummaryViewDotsButtonActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(task: GetReportSubjectTask(with: .ad),
                                                         type: RestArrayResponse<ReportSubject>.self)

                let items = response.itemsForSelection()
                let selectionPresentation = ReportSubjectSelectionPresentation(delegate: self, items: items)
                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                    view?.stopUserSummaryViewDotsButtonActivityIndicatorView()
                    coordinator.selectionBottomPopUp(presentation: selectionPresentation)
                }
            }
            catch let error {
                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    func activateAdvertButtonTapped() {
        guard (advert?.user.id == authenticator.userID) else {
            return
        }

        view?.startActivateAdvertButtonActivityIndicatorView()
        Task {
            guard let advert = advert else { return }
            let task = PutActivateAdvertTask(advertID: advert.id.string, userID: authenticator.userID)
            do {
                let _ = try await service.execute(task: task, type: RestObjectResponse<EmptyResponse>.self)
                ActivateAdvertFirebaseEvent(label: advert.type.title, parameters: advert.eventParameters()).send()
                safeSync {
                    view?.stopActivateAdvertButtonActivityIndicatorView()
                    coordinator.dismiss(animated: true) { [weak self] in
                        self?.dismissCompletion?(true)
                    }
                }
            }
            catch let error {
                safeSync {
                    view?.stopActivateAdvertButtonActivityIndicatorView()
                }
                error.showAlert()
            }
        }
    }
}

// MARK: - ViewModelLifeCycle
extension AdvertViewModel: ViewModelLifeCycle {
    func viewDidLoad() {
        view?.startActivityIndicatorView()
        view?.setContentStackViewVisibility(isHidden: true, animated: false)
        view?.setRemoveAdvertsButtonVisibility(isHidden: !isRemovingActive)
        view?.setApplyButtonButtonVisibility(isHidden: isRemovingActive)
        view?.setDismissButton(completion: nil)
        view?.setNavigationBarBackgroundColor(color: colorCode.colorFromHEX)
        
        Task {
            do {
                let response = try await service.execute(
                    task: GetAdvertTask(id: id),
                    type: RestObjectResponse<Advert>.self
                )
                
                await MainActor.run {
                    view?.stopActivityIndicatorView()
                    view?.setContentStackViewVisibility(isHidden: false, animated: false)
                    advert = response.data
                    colorCode = response.data.type.colorCode
                    view?.setNavigationBarBackgroundColor(color: response.data.type.colorCode.colorFromHEX)
                    
                    view?.setTitle(response.data.type.title)
                    view?.setNavigationBarTitleAttributes(
                        [.foregroundColor: AppTheme.Color.white.uiColor]
                    )

                    prepareUserSummary(response.data)
                    view?.setRemoveAdvertsButtonVisibility(isHidden: response.data.user.id != AuthenticationService.shared.userID)

                    let isOwner = (response.data.user.id == AuthenticationService.shared.userID)
                    let isApplyButtonHidden = AuthenticationService.shared.isAuthenticated ? isOwner : false
                    view?.setApplyButtonButtonVisibility(isHidden: isApplyButtonHidden)

                    view?.setDescriptionLabel(description: response.data.description.emptyIfNil)
                    
                    prepareGenres(response.data)
                    prepareOtherSections(response.data)
                }
            }
            catch {
                error.showAlert()
            }
        }
    }
    
    private func prepareUserSummary(_ advert: Advert) {
        let shouldShowDotsButton = advert.user.id != AuthenticationService.shared.userID
        let avatarPresentation = AvatarPresentation(
            kind: .custom(.init(size: .custom(72), radius: .medium)),
            source: .url(advert.user.avatarURL)
        )
        let userSummaryPresentation = UserSummaryPresentation(
            avatarPresentation: avatarPresentation,
            shouldShowDotsButton: shouldShowDotsButton,
            name: advert.user.name.attributed(color: .white, font: .regularHeading),
            location: advert.location.title.attributed(color: .white, font: .regularBody),
            cardTitle: .empty,
            updateDate: advert.updateDate.attributed(color: .white, font: .regularBody)
        )
        view?.configureUserSummaryView(with: userSummaryPresentation)
    }
    
    private func prepareGenres(_ advert: Advert) {
        let genreItemTitleStyle = TextAppearancePresentation(color: .white, font: .lightBody)
        let genreItems: [MusicGenreItemPresentation] = advert.genres.lazy.map {
            MusicGenreItemPresentation(genre: $0, titleStyle: genreItemTitleStyle)
        }
        let text = String("MusicGenre", table: .common)
        let genresPresentation = MusicGenresPresentation(
            title: text.attributed(color: .white, font: .lightBody),
            cellBorderColor: advert.type.colorCode.colorFromHEX,
            items: genreItems
        )
        view?.configureGenresView(with: genresPresentation)
    }
    
    private func prepareOtherSections(_ advert: Advert) {
        let genreItemTitleStyle = TextAppearancePresentation(color: .white, font: .lightBody)
        if advert.type.id == 4 {
            let genreItems: [MusicGenreItemPresentation] = advert.serviceTypes.lazy.map {
                MusicGenreItemPresentation(genre: $0, titleStyle: genreItemTitleStyle)
            }
            let text = String("LessonFormat", table: .common)
            let genresPresentation = MusicGenresPresentation(
                title: text.attributed(color: .white, font: .lightBody),
                cellBorderColor: advert.type.colorCode.colorFromHEX,
                items: genreItems
            )
            view?.configureInstructionTypesView(with: genresPresentation)

            // Skills
            let instructionServices: [MusicGenreItemPresentation] = advert.skills.lazy.map {
                MusicGenreItemPresentation(genre: $0, titleStyle: genreItemTitleStyle)
            }
            let instructionServicesPresentation = MusicGenresPresentation(
                title: advert.type.skillTitle.attributed(color: .white, font: .lightBody),
                cellBorderColor: advert.type.colorCode.colorFromHEX,
                items: instructionServices
            )

            view?.configureGenresView(with: instructionServicesPresentation)
            view?.configureSkillsView(with: .empty)
        } else if [3,5].contains(advert.type.id) {
            let instructionServices: [MusicGenreItemPresentation] = advert.skills.lazy.map {
                MusicGenreItemPresentation(genre: $0, titleStyle: genreItemTitleStyle)
            }
            let instructionServicesPresentation = MusicGenresPresentation(
                title: advert.type.skillTitle.attributed(color: .white, font: .lightBody),
                cellBorderColor: advert.type.colorCode.colorFromHEX,
                items: instructionServices
            )

            view?.configureGenresView(with: instructionServicesPresentation)
            view?.configureSkillsView(with: .empty)
        } else {
            // Skills
            let skillsPresentation = SkillsPresentation(
                type: .advert(imageViewContainerViewBorderColor: advert.type.colorCode.colorFromHEX),
                title: advert.type.skillTitle.attributed(color: .white, font: .lightBody),
                skillTitleStyle: .init(color: .white, font: .lightBody),
                skills: advert.skills
            )
            view?.configureSkillsView(with: skillsPresentation)
        }
    }

    func viewWillAppear() {
        view?.setNavigationBarBackgroundColor(color: colorCode.colorFromHEX)

        MixPanelScreenViewEvent(
            parameters: [
                "screen": "Advert",
                "advertID": id.string
            ]
        ).send()
    }
}

// MARK: - ReportSubjectSelectionDelegate
extension AdvertViewModel: ReportSubjectSelectionDelegate {
    func reportSubjectDidSelect(subject: SelectionInput?) {
        view?.startSendMessageButtonActivityIndicatorView()
        Task {
            let request = PostReportSubjectRequest(reportedAdId: id, reportedUserId: advert?.user.id ?? .empty, reportTopicId: subject?.id ?? .zero)
            do {
                let _ = try await service.execute(task: PostReportSubjectTask(with: .ad, request: request),
                                                  type: RestObjectResponse<EmptyResponse>.self)

                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                }

                await AlertService.show(message: String("Common.Report.Success", table: .common), 
                                        actions: [.okay()])
            }
            catch let error {
                safeSync {
                    view?.stopSendMessageButtonActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }
}

// MARK: - Location
extension RestArrayResponse where T == ReportSubject {

    func itemsForSelection() -> [ReportSubjectSelectionInput] {
        let items: [ReportSubjectSelectionInput] = data.compactMap { subject in
            return ReportSubjectSelectionInput(
                id: subject.id,
                title: subject.title,
                isSelected: false
            )
        }
        return items
    }
}

// MARK: - Events
struct AdjustRemoveCardEvent: AdjustEvent {
    var token: String = "juq6ua"
}

// MARK: - DeleteAdvertFeedbackSelectionDelegate
extension AdvertViewModel: DeleteAdvertFeedbackSelectionDelegate {
    func deleteAdvertFeedbackDidSelect(output: DeleteAdvertFeedbackSelectionInput?) {
        guard let output = output else {
            return
        }
        let request = FeedbackRequest(
            feedbackSubject: FeedbackSubject(id: output.id, title: output.title),
            message: .space
        )
        let removeAction = AlertService.action(title: String("Advert.DeleteAd", table: .home),
                                               style: .destructive, action: { [weak self] in
            self?.remove(feedback: request)
        })
        AlertService.show(message: "Are you sure you want to delete this ad?",
                          actions: [removeAction, .cancel()])
    }
}

struct DeleteAdvertFirebaseEvent: FirebaseEvent {
    var name: String = "delete_card"
    var category: String = "Card"
    var label: String
    var action: String = "Delete"

    var parameters: Payload
}

struct ZuhalAcademyActionAdjustEvent: AdjustEvent {
    var token: String = "xy012u"
}

struct ZuhalAcademyActionFirebaseEvent: FirebaseEvent {
    var name: String = "click_education"

    var category: String = "Zuhal Akademi"
    var action: String = "Click Button"
}

struct ActivateAdvertFirebaseEvent: FirebaseEvent {
    var name: String = "recreate_card"
    var category: String = "Card"
    var action: String = "Recreate"
    var label: String

    var parameters: Payload

    init(label: String, parameters: Payload) {
        self.label = label
        self.parameters = parameters
    }
}
