//
//  +Project.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription

public extension Project {
   static func make(
      module: Module,
      product: Product,
      infoPlist: InfoPlist = .default,
      needResources: Bool = false,
      targetResources: ResourceFileElements? = nil,
      targetDependencies: [TargetDependency] = [],
      targetBaseSettings: ProjectDescription.SettingsDictionary = [:],
      additionalFiles: [FileElement] = []
   ) -> Project {
      Project(
         name: module.toName,
         organizationName: ProjectConfiguration.organizationName,
         options: .options(
            automaticSchemesOptions: .disabled
         ),
         settings: .settings(
            configurations: [
               .debug(
                  name: ProjectConfiguration.debugConfig,
                  settings: ["SWIFT_ACTIVE_COMPILATION_CONDITIONS": "DEBUG"]
               )
            ]
         ),
         targets: [
            Target.make(
               name: module.toName,
               product: product,
               infoPlist: infoPlist,
               resources: needResources ? ProjectConfiguration.resources : nil,
               dependencies: targetDependencies
            )
         ],
         schemes: [
            .scheme(
               name: module.toName + ProjectConfiguration.debugConfig.toString(),
               buildAction: .buildAction(targets: [.project(path: module.toPath, target: module.toName)]),
               runAction: .runAction(configuration: ProjectConfiguration.debugConfig)
            )
         ],
         fileHeaderTemplate: .string("hankyeol-dev. \(module.toName)"),
         additionalFiles: additionalFiles
      )
   }
}
