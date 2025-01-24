//
//  Project.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
   module: .app,
   product: .app,
   infoPlist: ProjectConfiguration.infoPlist,
   needResources: true,
   targetDependencies: [
      .project(target: Module.auth.toName, path: Module.auth.toPath),
      .project(target: Module.profile.toName, path: Module.profile.toPath),
      .project(target: Module.map.toName, path: Module.map.toPath),
      .project(target: Module.post.toName, path: Module.post.toPath),
      .project(target: Module.chat.toName, path: Module.chat.toPath),
      .project(target: Module.domain.toName, path: Module.domain.toPath),
      .project(target: Module.data.toName, path: Module.data.toPath),
      .external(name: Library.rxSwift.rawValue),
      .external(name: Library.nMap.rawValue),
      .external(name: Library.iqKeyboard.rawValue)
   ]
)
