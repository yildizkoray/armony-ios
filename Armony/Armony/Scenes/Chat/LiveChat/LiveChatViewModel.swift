//
//  ChatViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 18.11.22.
//

import Foundation

final class LiveChatViewModel: ViewModel {

    var coordinator: LiveChatCoordinator!
    private weak var view: LiveChatViewDelegate?

    private(set) var socket: SocketClient!
    private lazy var authenticator: AuthenticationService = .shared

    private(set) lazy var currentUser = LiveChatMessagePresentation.Owner(senderId: authenticator.userID, displayName: .empty)
    
    var receiver: LiveChatPresentation.ReceiverPresentation {
        return presentation.receiver
    }

    private var advertType: String? = nil

    private var presentation: LiveChatPresentation = .empty

    // Chat ID
    private let id: Int

    var numberOfItemsInSection: Int {
        return presentation.messages.count
    }

    var cardPresentation: CardPresentation {
        return presentation.cardPresentation
    }

    init(view: LiveChatViewDelegate, id: Int) {
        self.view = view
        self.id = id
        super.init()

        do {
            let socketURL = try SocketLiveChatTask(userID: authenticator.userID, chatID: id).asURL()
            self.socket = SocketClient(socketURL: socketURL, delegate: self)
        }
        catch let error {
            FirebaseCrashlyticsLogger.shared.log(error: error)
            AlertService.show(error: error.api, actions: [.okay()])
        }
    }

    deinit {
        socket.closeConnection()
    }

    func message(at indexPath: IndexPath) -> LiveChatMessagePresentation {
        return presentation.messages[indexPath.section]
    }

    func sendMessage(text: String, completion: @escaping VoidCallback) {
        socket.write(text: text.trimmingCharacters(in: .newlines)) { [weak self] in
            guard let self = self else { return }
            if self.presentation.messages.isEmpty {
                AdjustSendFirstMessageEvent().send()
                SendFirstMessageFirebaseEvent(advertType: advertType.emptyIfNil).send()
            }
            safeSync {
                completion()
            }
        }
    }

    // Fetch previous messages
    func fetchMessages() {
        view?.startActivityIndicatorView()
        let task = GetLiveChatMessagesTask(userID: authenticator.userID, chatID: id)

        Task {
            do {
                let response = try await service.execute(task: task,
                                                         type: RestObjectResponse<LiveChatResponse>.self)

                advertType = response.data.chat.ad.type.title

                let messages = response.data.messages.map {
                    let senderType = LiveChatMessagePresentation.Owner(senderId: $0.owner.id, displayName: $0.owner.name)
                    return LiveChatMessagePresentation(
                        sender: senderType,
                        messageId: $0.id.string,
                        sentDate: $0.date,
                        kind: .text($0.content)
                    )
                }

                presentation = LiveChatPresentation(
                    cardPresentation: CardPresentation(advert: response.data.chat.ad),
                    messages: messages,
                    receiver: .init(id: response.data.receiver.id, name: response.data.receiver.name)
                )

                MixPanelScreenViewEvent(
                    parameters: [
                        "screen": "LiveChat",
                        "advertID": response.data.chat.ad.id
                    ]
                ).send()

                safeSync {
                    view?.stopActivityIndicatorView()

                    let titleViewPresentation = LiveChatNavigationTitlePresentation(
                        avatarURL: response.data.receiver.avatarURL,
                        name: response.data.receiver.name
                    )
                    view?.configureNavigationTitleView(presentation: titleViewPresentation)
                    view?.reloadData()
                }
            }
            catch let error {
                error.showAlert()
                safeSync {
                    view?.stopActivityIndicatorView()
                }
            }
        }
    }

    func blockUser() {
        view?.startSendButtonActivityIndicatorView()
        view?.startRightBarButtonItemActivityIndicatorView()
        Task {
            do {
                let request = PostBlockUserRequest(blockedUserId: presentation.receiver.id)

                let _ = try await service.execute(
                    task: PostBlockUserTask(userID: authenticator.userID, request: request),
                    type: RestObjectResponse<EmptyResponse>.self
                )

                safeSync {
                    NotificationCenter.default.post(notification: .newMessageDidSend)
                    view?.stopRightBarButtonItemActivityIndicatorView()
                    view?.stopSendButtonActivityIndicatorView()
                    coordinator.pop()
                }
            }
            catch let error {
                safeSync {
                    view?.stopSendButtonActivityIndicatorView()
                    view?.stopRightBarButtonItemActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    func reportActionDidTap() {
        view?.startSendButtonActivityIndicatorView()
        view?.startRightBarButtonItemActivityIndicatorView()
        Task {
            do {
                let response = try await service.execute(task: GetReportSubjectTask(with: .ad),
                                                         type: RestArrayResponse<ReportSubject>.self)

                let items = response.itemsForSelection()
                let selectionPresentation = ReportSubjectSelectionPresentation(delegate: self, items: items)
                safeSync {
                    view?.stopSendButtonActivityIndicatorView()
                    view?.stopRightBarButtonItemActivityIndicatorView()
                    coordinator.selectionBottomPopUp(presentation: selectionPresentation)
                }
            }
            catch let error {
                safeSync {
                    view?.stopSendButtonActivityIndicatorView()
                    view?.stopRightBarButtonItemActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }
}

// MARK: - WebSocketDelegate
extension LiveChatViewModel: SocketClientDelegate {
    func socketDidConnect(client: SocketClient) {
        print("func socketDidConnect(client: SocketClient)")
    }

    func socketDidDisconnect(client: SocketClient) {
        view?.stopSendButtonActivityIndicatorView()

        let exception = Exception(name: "socketDidDisconnect", reason: "socketDidDisconnect")
        FirebaseCrashlyticsLogger.shared.log(exception: exception)
    }

    func socket(_ client: SocketClient, didDisconnectWithError error: Error?) {
        view?.stopSendButtonActivityIndicatorView()
        print("didDisconnectWithError:", error.debugDescription)
        FirebaseCrashlyticsLogger.shared.log(error: error)
    }

    func socket(_ client: SocketClient, didReceive response: String) {
        do {
            let message = try responseDecoder.decode(response: response, for: RestObjectResponse<LiveChatMessage>.self).data

            let sender = LiveChatMessagePresentation.Owner(senderId: message.owner.id, displayName: message.owner.name)
            let newMessage = LiveChatMessagePresentation(
                sender: sender,
                messageId: message.id.string,
                sentDate: message.date,
                kind: .text(message.content)
            )

            safeSync {
                presentation.messages.append(newMessage)
                view?.insertMessages(indexSet: IndexSet(integer: presentation.messages.count - 1))
            }
        } catch let error {
            error.showAlert {
                NotificationCenter.default.post(notification: .newMessageDidSend)
                self.coordinator.pop()
            }
        }
    }
}

// MARK: - ReportSubjectSelectionDelegate
extension LiveChatViewModel: ReportSubjectSelectionDelegate {
    func reportSubjectDidSelect(subject: SelectionInput?) {
        view?.startSendButtonActivityIndicatorView()
        view?.startRightBarButtonItemActivityIndicatorView()
        let receiverID = presentation.receiver.id
        Task {
            let request = PostReportSubjectRequest(reportedAdId: .zero,
                                                   reportedUserId: receiverID,
                                                   reportTopicId: subject?.id ?? .zero)
            do {
                let _ = try await service.execute(task: PostReportSubjectTask(with: .ad, request: request),
                                                  type: RestObjectResponse<EmptyResponse>.self)

                safeSync {
                    view?.stopSendButtonActivityIndicatorView()
                    view?.stopRightBarButtonItemActivityIndicatorView()
                }

                await AlertService.show(message: String("Common.Report.Success", table: .common), 
                                        actions: [.okay()])
            }
            catch let error {
                safeSync {
                    view?.stopSendButtonActivityIndicatorView()
                    view?.stopRightBarButtonItemActivityIndicatorView()
                }
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }
}

fileprivate extension Advert {

    func cardPresentation() -> CardPresentation {
        let colorCode = type.colorCode

        let userSummaryPresentation = UserSummaryPresentation(
            avatarPresentation: .init(kind: .custom(.init(size: .custom(72))), source: .url(user.avatarURL)),
            name: user.name.attributed(color: .white, font: .regularBody),
            location: location.title.attributed(color: .white, font: .regularBody),
            cardTitle: type.title.attributed(.armonyWhite, font: .semiboldSubheading), 
            updateDate: updateDate.attributed(color: .white, font: .regularBody)
        )

        let skillsPresentation = SkillsPresentation(
            type: .adverts(imageViewContainerBackgroundColor: colorCode.colorFromHEX),
            title: type.skillTitle.attributed(color: .white, font: .lightBody),
            skillTitleStyle: TextAppearancePresentation(color: .white, font: .regularBody),
            skills: skills
        )

        return CardPresentation(id: id,
                                colorCode: colorCode,
                                isActive: isActive, 
                                status: status,
                                userSummaryPresentation: userSummaryPresentation,
                                skillsPresentation: skillsPresentation)
    }
}


// MARK: - Events
struct AdjustSendFirstMessageEvent: AdjustEvent {
    var token: String = "ahnogp"
}

struct SendFirstMessageFirebaseEvent: FirebaseEvent {
    var name: String = "message"
    var label: String
    var category: String = "Message"
    var action: String = "Send"

    init(advertType: String) {
        self.label = advertType
    }
}
