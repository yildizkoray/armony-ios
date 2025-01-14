import Alamofire
import Foundation

struct DeleteChatTask: HTTPTask {
    var method: HTTPMethod = .delete
    var path: String

    init(userID: String, chatID: String) {
        path = "/users/\(userID)/chats/\(chatID)"
    }
} 
