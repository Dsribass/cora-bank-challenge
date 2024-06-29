import Foundation
import Combine

public final class AuthLocalDataSource {
  public init() {}

  private struct Keys {
    static let token = "token"
  }

  func saveUserToken(_ token: String) -> AnyPublisher<(), Error> {
    Future { promise in
      let data = Data(token.utf8)
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: Keys.token,
        kSecValueData as String: data
      ]

      SecItemDelete(query as CFDictionary)

      let status = SecItemAdd(query as CFDictionary, nil)
      if status == errSecSuccess {
        promise(.success(()))
      } else {
        promise(.failure(CommonError.unexpected))
      }
    }.eraseToAnyPublisher()
  }

  func getUserToken() -> AnyPublisher<String, Error> {
    Future { promise in
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: Keys.token,
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
      ]

      var item: CFTypeRef?
      let status = SecItemCopyMatching(query as CFDictionary, &item)

      if status == errSecSuccess {
        if let data = item as? Data, let token = String(data: data, encoding: .utf8) {
          promise(.success(token))
        } else {
          promise(.failure(CommonError.itemNotFound))
        }
      } else {
        promise(.failure(CommonError.itemNotFound))
      }
    }.eraseToAnyPublisher()
  }

  func deleteUserToken() -> AnyPublisher<(), Error> {
    Future { promise in
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: Keys.token
      ]

      let status = SecItemDelete(query as CFDictionary)
      if status == errSecSuccess || status == errSecItemNotFound {
        promise(.success(()))
      } else {
        promise(.failure(CommonError.itemNotFound))
      }
    }.eraseToAnyPublisher()
  }
}
