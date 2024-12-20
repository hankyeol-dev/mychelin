//
//  +Target.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription

public extension Target {
    static func make(
        name: String,
        destinations: Destinations = [.iPhone],
        product: Product,
        minimumVersion: String = ProjectConfiguration.minimumVersion,
        infoPlist: InfoPlist = .default,
        sources: SourceFilesList = ProjectConfiguration.sources,
        resources: ResourceFileElements?,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return .target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: ProjectConfiguration.organizationName + name,
            deploymentTargets: .iOS(minimumVersion),
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            dependencies: dependencies
        )
    }
}
