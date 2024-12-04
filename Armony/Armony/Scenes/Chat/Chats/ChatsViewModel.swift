//
//  ChatsViewModel.swift
//  Armony
//
//  Created by Koray Yıldız on 16.11.22.
//

import Foundation

final class ChatsViewModel: ViewModel {

    var coordinator: ChatsCoordinator!
    private weak var view: ChatsViewDelegate?

    private lazy var getChatsTask = GetChatsTask(userID: authenticator.userID)
    private lazy var paginator = Paginator(task: getChatsTask)
    private var shouldFetchMessagesAtViewWillAppear = false

    private var messages: [ChatItemPresentation] = .empty {
        didSet {
            safeSync {
                toggleEmptyState()
            }
        }
    }

    var hasNextPage: Bool {
        return paginator.hasNext
    }

    private lazy var authenticator = AuthenticationService.shared

    var numberOfItemsInSections: Int {
        return messages.count
    }

    func message(at indexPath: IndexPath) -> ChatItemPresentation {
        return messages[indexPath.row]
    }

    init(view: ChatsViewDelegate) {
        self.view = view
        super.init()
    }

    func fetchMessages() {
        Task {
            do {
                let response = try await paginator.execute(service: service, type: RestArrayResponse<Chat>.self)

                messages = response.data.map {
                    return ChatItemPresentation(
                        id: $0.id,
                        avatarURL: $0.user.avatarURL,
                        title: $0.user.name,
                        previewMessage: $0.lastMessage,
                        isRead: $0.isRead
                    )
                }

                safeSync {
                    view?.endRefreshing()
                    view?.stopActivityIndicatorView()
                    view?.setTableViewVisibility(isHidden: false)
                    view?.reloadData()
                }
            }
            catch {
                safeSync {
                    view?.endRefreshing()
                    view?.setTableViewVisibility(isHidden: false)
                    view?.stopActivityIndicatorView()
                }
            }
        }
    }

    func next() {
        Task {
            do {
                let response = try await paginator.next(service: service, type: RestArrayResponse<Chat>.self)
                let newPresentations = response.data.map {
                    return ChatItemPresentation(
                        id: $0.id,
                        avatarURL: $0.user.avatarURL,
                        title: $0.user.name,
                        previewMessage: $0.lastMessage,
                        isRead: $0.isRead
                    )
                }

                safeSync {
                    messages.append(contentsOf: newPresentations)
                    view?.reloadData()
                }
            }
            catch let error {
                await AlertService.show(error: error.api, actions: [.okay()])
            }
        }
    }

    func toggleEmptyState() {
        if messages.isEmpty {
            view?.showEmptyStateView(with: .noContent)
        }
        else {
            view?.hideEmptyStateView(animated: false)
        }
    }

    @objc private func newMessageDidSend() {
        shouldFetchMessagesAtViewWillAppear = true
    }
}

// MARK: - ViewModelLifeCycle
extension ChatsViewModel: ViewModelLifeCycle {
 
    func viewDidLoad() {
        view?.setTableViewVisibility(isHidden: true)
        view?.setTitle(String("Chat.Title", table: .chat))
        view?.startActivityIndicatorView()
        fetchMessages()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newMessageDidSend),
                                               name: .newMessageDidSend,
                                               object: nil)

        MixPanelScreenViewEvent(
            parameters: [
                "screen": "Chats",
            ]
        ).send()
    }

    func viewWillAppear() {
        if shouldFetchMessagesAtViewWillAppear {
            fetchMessages()
            shouldFetchMessagesAtViewWillAppear = false
        }
    }
}

// MARK: - EmptyStatePresentation
private extension EmptyStatePresentation {

    static var noContent: EmptyStatePresentation = {
        let title = String("Chat.EmptyState.Title", table: .chat).emptyStateTitleAttributed
        return EmptyStatePresentation(image: .chatsEmptyStateIcon, title: title)
    }()
}
