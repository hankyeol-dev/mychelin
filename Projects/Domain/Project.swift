//
//  Project.swift
//  Config
//
//  Created by 강한결 on 12/20/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
   module: .domain,
   product: .framework,
   targetDependencies: [
      .external(name: Library.rxSwift.rawValue),
      .external(name: Library.kingfisher.rawValue),
      .external(name: Library.rxData.rawValue),
      .external(name: Library.rxLocation.rawValue),
      .external(name: Library.then.rawValue)
   ]
)
