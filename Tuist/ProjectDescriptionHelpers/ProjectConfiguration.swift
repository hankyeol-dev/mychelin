//
//  ProjectConfiguration.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import Foundation
import ProjectDescription

public enum ProjectConfiguration {
    public static let appName: String = "Slp2_Project"
    public static let organizationName: String = "team.hk.slp2"
    public static let minimumVersion: String = "16.0"
    public static let infoPlist: InfoPlist = .file(path: .path("Support/Info.plist"))
    public static let bundleId: String = "\(organizationName).\(appName)"
    public static let sources: SourceFilesList = "Sources/**"
    public static let resources: ResourceFileElements = [.glob(pattern: "Resources/**")]
    public static let debugConfig: ConfigurationName = "Debug"
}

public extension ConfigurationName {
    func toString() -> String { self.rawValue }
}
