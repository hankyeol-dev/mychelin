//
//  Workspace.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
   name: ProjectConfiguration.appName,
   projects: [
      "Projects/**",
      "DemoApps/**"
   ],
   schemes: [
      .scheme(
         name: "app",
         buildAction: .buildAction(targets: [.project(path: Module.app.toPath, target: Module.app.toName)]),
         runAction: .runAction(configuration: ProjectConfiguration.debugConfig)
      )
   ]
)
