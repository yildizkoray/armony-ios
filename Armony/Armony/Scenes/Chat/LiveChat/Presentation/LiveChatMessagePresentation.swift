//
//  LiveChatMessage.swift
//  Armony
//
//  Created by Koray Yildiz on 29.12.22.
//

import Foundation
import MessageKit

struct LiveChatPresentation {
    struct ReceiverPresentation {
        let id: String
        let name: String

        init(id: String, name: String) {
            self.id = id
            self.name = name
        }

        static let empty = ReceiverPresentation(id: .empty, name: .empty)
    }

    let cardPresentation: CardPresentation
    var messages: [LiveChatMessagePresentation]
    let receiver: ReceiverPresentation

    init(cardPresentation: CardPresentation, messages: [LiveChatMessagePresentation], receiver: ReceiverPresentation) {
        self.cardPresentation = cardPresentation
        self.messages = messages
        self.receiver = receiver
    }

    // MARK: - EMPTY
    static let empty = LiveChatPresentation(cardPresentation: .empty, messages: .empty, receiver: .empty)
}

struct LiveChatMessagePresentation: MessageType {
    struct Owner: SenderType {
        var senderId: String
        var displayName: String

        init(senderId: String, displayName: String) {
            self.senderId = senderId
            self.displayName = displayName
        }
    }

    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind

    init(sender: SenderType, messageId: String, sentDate: String, kind: MessageKind) {
        self.sender = sender
        self.messageId = messageId
        self.sentDate = Date()
        self.kind = kind
    }
}
