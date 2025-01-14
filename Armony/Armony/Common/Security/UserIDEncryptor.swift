import Foundation
import zlib

final class UserIDEncryptor {
    
    static let shared = UserIDEncryptor()
    private init() {}
    
    func encrypt(_ userID: String) -> String {
        let pepperedID = userID + RemoteConfigService.shared[.pepper]
        guard let data = pepperedID.data(using: .utf8) else { return userID }
        
        let crc32 = data.withUnsafeBytes { bufferPointer -> UInt32 in
            let length = UInt32(data.count)
            return UInt32(zlib.crc32(.zero, bufferPointer.baseAddress, length))
        }
        
        return String(format: "%08x", crc32)
    }
}
