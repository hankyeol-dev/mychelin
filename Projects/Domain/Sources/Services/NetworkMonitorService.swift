// hankyeol-dev. Domain

import Foundation
import Network

public final class NetworkMonitorService {
   private let queue = DispatchQueue.global()
   private let monitor = NWPathMonitor()
   
   public static let shared = NetworkMonitorService()
   public private(set) var isNetworkConnected: Bool = false
   public private(set) var networkConnectionType: NetworkConnectionType = .unknown
   
   public enum NetworkConnectionType {
      case wifi
      case cellular
      case unknown
   }
   
   private init() {}
}

extension NetworkMonitorService {
   public func startMonitor(_ handler: @escaping (Bool) -> Void) {
      monitor.start(queue: queue)
      monitor.pathUpdateHandler = { [weak self] path in
         guard let self else { return }
         isNetworkConnected = path.status == .satisfied
         setNetworkConnectionType(path)
         
         DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            handler(isNetworkConnected)
         }
      }
   }
   
   public func stopMonitor() {
      monitor.cancel()
   }
   
   private func setNetworkConnectionType(_ path: NWPath) {
      if path.usesInterfaceType(.wifi) {
         networkConnectionType = .wifi
      }
      else if path.usesInterfaceType(.cellular) {
         networkConnectionType = .cellular
      }
      else {
         networkConnectionType = .unknown
      }
      print("networkConnectionType", networkConnectionType)
   }
}
