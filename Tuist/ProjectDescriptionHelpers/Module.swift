//
//  Module.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription

public enum Module: CaseIterable {
   /// - App Module
   case app
   
   /// - DemoApp Module
   case demoLoginApp
//   case demoMapApp
   
   /// - Feature Module
   case auth
   case map
   case post
   case profile
   case chat
   
   /// Logic and UI
   case common
   case commonUI
   case domain
   case data
}

public extension Module {
   var toName: String {
      switch self {
      case .app: return "App"
      case .demoLoginApp: return "DemoLoginApp"
//      case .demoMapApp: return "DemoMapApp"
      case .auth: return "Auth"
      case .map: return "Map"
      case .post: return "Post"
      case .profile: return "Profile"
      case .chat: return "Chat"
      case .common: return "Common"
      case .commonUI: return "CommonUI"
      case .domain: return "Domain"
      case .data: return "Data"
      }
   }
   
   var toPath: Path {
      switch self {
      case .demoLoginApp:
         return .relativeToRoot("DemoApps/\(toName)")
      case .auth, .map, .post, .profile, .chat:
         return .relativeToRoot("Projects/Features/\(toName)")
      default:
         return .relativeToRoot("Projects/\(toName)")
      }
   }
}
