import Foundation
import Security

struct TokenKey{
    static let tokenAccess = "access_token"
}

class TokenService {
    static let shared = TokenService()   
    
    func storeToken(with token: String) {
        let tokenData = token.data(using: .utf8)
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: TokenKey.tokenAccess,
            kSecValueData: tokenData!,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
    }
    
    func retrieveToken() -> String {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: TokenKey.tokenAccess,
            kSecReturnData: kCFBooleanTrue!,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return ""
        }
    }
    
    func deleteToken() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: TokenKey.tokenAccess,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
    }
    
    func getTokenFromKeychain() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: TokenKey.tokenAccess,
            kSecReturnData: kCFBooleanTrue as Any,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }
}




