//
//  Project.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
   module: .commonUI,
   product: .framework,
   needResources: true,
   targetDependencies: [
      .project(target: Module.domain.toName, path: Module.domain.toPath),
      .external(name: Library.snapkit.rawValue),
      .external(name: Library.rxCocoa.rawValue),
      .external(name: Library.rxSwift.rawValue),
      .external(name: Library.textField.rawValue),
      .external(name: Library.then.rawValue),
      .external(name: Library.kingfisher.rawValue),
      .external(name: Library.rxData.rawValue),
      .external(name: Library.reusable.rawValue)
   ]
)
