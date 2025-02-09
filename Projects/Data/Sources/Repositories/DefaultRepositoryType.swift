// hankyeol-dev. Data

import Foundation
import Domain
import Kingfisher

public protocol DefaultRepositoryType {
   func request<O: Decodable>(_ router: RouterProtocol, of : O.Type) async -> Result<O, NetworkError>
}

public extension DefaultRepositoryType {
   func request<O: Decodable>(_ router: RouterProtocol, of : O.Type) async -> Result<O, NetworkError> {
      do {
         let data = try await NetworkService.request(router: router, of: of)
         return .success(data)
      } catch NetworkError.expiredAccessToken {
         do {
            let output = try await NetworkService.request(
               router: AsyncAuthRouter.login(.init(email: env.tempEmail, password: env.tempPW)),
               of: LoginOutputType.self)

            UserDefaultsProvider.shared.setBoolValue(.isLogined, value: true)
            UserDefaultsProvider.shared.setStringValue(.accessToken, value: output.accessToken)
            UserDefaultsProvider.shared.setStringValue(.refreshToken, value: output.refreshToken)
            KingfisherManager.shared.setImageRequestHeader()
            
            return await request(router, of: of)
            
         } catch {
            print("expiredAccessToken catch", error)
            UserDefaultsProvider.shared.setBoolValue(.isLogined, value: false)
            return .failure(.invalidAccessToken)
         }
      } catch {
         print("request catch", error)
         return .failure(error as? NetworkError ?? .noData)
      }
   }
}
