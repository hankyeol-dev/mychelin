//
//  Project.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
   module: .demoLoginApp,
   product: .app,
   infoPlist: ProjectConfiguration.infoPlist,
   needResources: true,
   targetDependencies: [
      .project(target: Module.auth.toName, path: Module.auth.toPath),
      .project(target: Module.domain.toName, path: Module.domain.toPath),
      .project(target: Module.data.toName, path: Module.data.toPath)
   ]
)
