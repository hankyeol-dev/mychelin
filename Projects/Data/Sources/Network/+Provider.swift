// hankyeol-dev. Data

import Foundation
import Moya
import Domain

extension MoyaProvider {
   func asyncRequest<Output: Decodable>(_ target: Target, of: Output.Type) async throws -> Output {
      try await withCheckedThrowingContinuation { continuation in
         self.request(target) { result in
            switch result {
            case let .success(res):
               do {
                  let data = try res.map(Output.self)
                  continuation.resume(returning: data)
               } catch {
                  continuation.resume(throwing: NetworkErrors.noData)
               }
            case .failure:
               _Concurrency.Task { [weak self] in
                  guard let self else { return }
                  if await refreshRequest() {
                     continuation.resume(returning: try await asyncRequest(target, of: of))
                  } else {
                     continuation.resume(throwing: NetworkErrors.tokenExpired)
                  }
               }
            }
         }
      }
   }
   
   private func refreshRequest() async -> Bool {
      do {
         let provider = MoyaProvider<AuthRouter>()
         let userProvider = UserDefaultsProvider.shared
         let token = userProvider.getStringValue(.refreshToken)
         let output = try await provider.asyncRequest(.refreshToken(refreshToken: token),
                                         of: TokenOutputType.self)
         userProvider.setStringValue(.accessToken, value: output.accessToken)
         userProvider.setStringValue(.refreshToken, value: output.refreshToken)
         return true
      } catch {
         return false
      }
   }
}
