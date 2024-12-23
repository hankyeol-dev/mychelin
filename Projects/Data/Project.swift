//
//  Project.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
   module: .data,
   product: .framework,
   targetDependencies: [
      .project(target: Module.domain.toName, path: Module.domain.toPath),
      .external(name: Library.rxSwift.rawValue),
      .external(name: Library.rxmoya.rawValue),
      .external(name: Library.moya.rawValue)
   ],
   additionalFiles: [.glob(pattern: "Sources/ENV/*")]
)
