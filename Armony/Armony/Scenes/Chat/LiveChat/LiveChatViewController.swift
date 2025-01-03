//
//  LiveChatViewController.swift
//  Armony
//
//  Created by Koray Yıldız on 18.11.22.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import IQKeyboardManagerSwift

protocol LiveChatViewDelegate: AnyObject,
                               ActivityIndicatorShowing,
                               NavigationBarCustomizing,
                               NavigationBarActivityIndicatorShowing {
    func configureNavigationTitleView(presentation: LiveChatNavigationTitlePresentation)
    func insertMessages(indexSet: IndexSet)
    func reloadData()
    func resetInputBar()

    func startSendButtonActivityIndicatorView()
    func stopSendButtonActivityIndicatorView()
}

final class LiveChatViewController: MessageKit.MessagesViewController, ViewController {

    static var storyboardName: UIStoryboard.Name = .chat

    private lazy var navigationTitleView = LiveChatNavigationTitleView()

    var viewModel: LiveChatViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .armonyBlack

        configureInputBar()
        configureCollectionView()
        configureNavigationBar()

        messagesCollectionView.messageCellDelegate = self
        viewModel.fetchMessages()
        viewModel.socket.openConnection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarBackgroundColor(color: .armonyBlack)
        IQKeyboardManager.shared.enable = false
    }

    deinit {
        IQKeyboardManager.shared.enable = true
    }

    fileprivate func configureCollectionView() {
        messagesCollectionView.backgroundColor = .clear
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.register(MessageSectionHeaderView.self,
                                        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
    }

    fileprivate func configureNavigationBar() {
        navigationItem.titleView = navigationTitleView
        setNavigationBarBackgroundColor(color: .armonyBlack)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .verticalDotsThree,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(dotsRightButtonDidTap))
    }

    @objc func dotsRightButtonDidTap() {
        let reportText = String("Report", table: .common)
        let blockText = String("Block", table: .common)
        let confirmation = String("Advert.Block.Confirmation", table: .home)
        let description = String("Advert.Block.Description", table: .home)
        let report = AlertService.action(title: reportText) { [weak self] in
            self?.viewModel.reportActionDidTap()
        }
        let block = AlertService.action(title: blockText, style: .destructive) {
            let blockAction = AlertService.action(title: blockText, style: .destructive) {
                self.viewModel.blockUser()
            }
            AlertService
                .show(title: confirmation,
                      message: description,
                      actions: [blockAction, .cancel()])
        }
        AlertService
            .actionSheet(
                sourceView: navigationItem.rightBarButtonItem?.value(forKey: "view") as? UIView,
                actions: [report, block, .cancel()]
            )
            .show(onto: self)
    }

    fileprivate func configureInputBar() {
        messageInputBar.delegate = self
        messageInputBar.backgroundView.backgroundColor = .armonyBlack

        // TextView
        messageInputBar.inputTextView.textColor = .armonyWhite
        messageInputBar.inputTextView.tintColor = .armonyWhiteMedium

        // SendButton
        messageInputBar.sendButton.activityViewColor = .armonyWhite
        messageInputBar.sendButton.setTitle(.empty, for: .normal)
        messageInputBar.sendButton.setImage(.chatInputSendbuttonIcon, for: .normal)
        messageInputBar.inputTextView.delegate = self
    }
}

// MARK: - ChatViewDelegate
extension LiveChatViewController: LiveChatViewDelegate {
    
    func configureNavigationTitleView(presentation: LiveChatNavigationTitlePresentation) {
        navigationTitleView.configure(presentation: presentation)

        navigationTitleView.addTapGestureRecognizer { [weak self] _ in
            guard let self = self else { return }
            VisitedAccountCoordinator(navigator: self.navigator).start(with: self.viewModel.receiver.id)
        }
    }
    
    func reloadData() {
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: false)
    }

    func insertMessages(indexSet: IndexSet) {
        messagesCollectionView.insertSections(indexSet) { [weak self] in
            self?.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }

    func resetInputBar() {
        messageInputBar.inputTextView.text = .empty
    }

    func startSendButtonActivityIndicatorView() {
        messageInputBar.sendButton.startAnimating()
    }

    func stopSendButtonActivityIndicatorView() {
        messageInputBar.sendButton.stopAnimating()
    }
}

// MARK: - MessagesDataSource
extension LiveChatViewController: MessagesDataSource {

    var currentSender: SenderType {
        return viewModel.currentUser
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return viewModel.numberOfItemsInSection
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return viewModel.message(at: indexPath)
    }

    func enabledDetectors(for message: MessageType,
                          at indexPath: IndexPath,
                          in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .phoneNumber, .hashtag]
    }
    func messageHeaderView(
        for indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) -> MessageReusableView {
        let headerView: MessageSectionHeaderView = messagesCollectionView.dequeueReusableHeaderView(
            MessageSectionHeaderView.self,
            for: indexPath
        )
        headerView.configure(cardPresentation: viewModel.cardPresentation) { [weak self] in
            if let self {
                self.viewModel.socket.closeConnection()
                AdvertCoordinator().start(with: self.viewModel.cardPresentation.id,
                                          colorCode: self.viewModel.cardPresentation.colorCode,
                                          isPreviousPageLiveChat: true) { _ in 
                    self.viewModel.socket.openConnection()
                    self.viewModel.fetchMessages()
                }
            }
        }
        return headerView
    }

    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        if section == .zero {
            return CGSize(width: messagesCollectionView.frame.size.width, height: 187 + 32)
        }
        return .zero
    }
}

// MARK: - MessagesDisplayDelegate, MessagesLayoutDelegate
extension LiveChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {
    func configureAvatarView(_ avatarView: MessageKit.AvatarView,
                             for message: MessageType,
                             at indexPath: IndexPath,
                             in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }

    func messageStyle(for message: MessageType,
                      at indexPath: IndexPath,
                      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .custom { containerView in
            containerView.makeAllCornersRounded(radius: .medium)
        }
    }

    func textColor(for message: MessageType,
                   at indexPath: IndexPath,
                   in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .armonyBlack
    }

    func backgroundColor(for message: MessageType,
                         at indexPath: IndexPath,
                         in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isFromCurrentSender(message: message) {
            return .armonyGreen
        }
        return .armonyWhite
    }
}

// MARK: - InputBarAccessoryViewDelegate
extension LiveChatViewController: InputBarAccessoryViewDelegate, UITextViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.sendButton.startAnimating()
        viewModel.sendMessage(text: text) { [weak self] in
            self?.resetInputBar()
            inputBar.sendButton.stopAnimating()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            AppRatingService.shared.requestReviewIfNeeded()
        }
    }
}

// MARK: MessageCellDelegate
extension LiveChatViewController: MessageCellDelegate {
    func didSelectURL(_ url: URL) {
        viewModel.coordinator.open(url: url)
    }
}
