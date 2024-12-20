//
//  Project.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
   module: .auth,
   product: .framework,
   targetDependencies: [
      .project(target: Module.domain.toName, path: Module.domain.toPath),
      .project(target: Module.common.toName, path: Module.common.toPath),
      .project(target: Module.commonUI.toName, path: Module.commonUI.toPath),
      .external(name: Library.snapkit.rawValue),
      .external(name: Library.rxSwift.rawValue),
      .external(name: Library.rxCocoa.rawValue),
   ]
)
