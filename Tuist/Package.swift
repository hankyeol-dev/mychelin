// swift-tools-version: 6.0
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

let packageSettings = PackageSettings(
   productTypes: [
      "Moya": .framework,
      "RxMoya": .framework,
      "ReactiveMoya": .framework,
      "RxSwift": .framework,
      "RxCocoa": .framework,
      "RxCocoaRuntime": .framework,
      "RxDataSources": .framework,
      "RxMKMapView": .framework,
      "RxCoreLocation": .framework,
      "RxGesture": .framework,
      "ReactorKit": .framework,
      "Kingfisher": .framework,
      "Then": .framework,
      "SnapKit": .framework,
      "SkyFloatingLabelTextField": .framework,
      "Reusable": .framework,
      "DropDown": .framework,
      "NMapsMap": .framework
   ],
   baseSettings: .settings(configurations: [
      .debug(name: ProjectConfiguration.debugConfig)
   ])
)
#endif

let package = Package(
   name: "Slp2_Project",
   platforms: [.iOS(.v16)],
   products: [
      .library(name: "Slp2_Project", targets: ["Slp2_Project"])
   ],
   dependencies: [
      .package(url: "https://github.com/Moya/Moya.git", from: "15.0.0"),
      .package(url: "https://github.com/ReactiveX/RxSwift.git", branch: "main"),
      .package(url: "https://github.com/ReactorKit/ReactorKit.git", from: "3.2.0"),
      .package(url: "git@github.com:RxSwiftCommunity/RxDataSources.git", branch: "main"),
      .package(url: "https://github.com/RxSwiftCommunity/RxMKMapView.git", branch: "master"),
      .package(url: "https://github.com/RxSwiftCommunity/RxCoreLocation.git", branch: "master"),
      .package(url: "git@github.com:onevcat/Kingfisher.git", branch: "master"),
      .package(url: "https://github.com/devxoul/Then.git", from: "3.0.0"),
      .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
      .package(url: "https://github.com/Skyscanner/SkyFloatingLabelTextField.git", from: "3.8.0"),
      .package(url: "https://github.com/AliSoftware/Reusable.git", branch: "main"),
      .package(url: "https://github.com/AssistoLab/DropDown.git", branch: "master"),
      .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", branch: "main"),
      .package(url: "https://github.com/navermaps/SPM-NMapsMap.git", branch: "main")
   ],
   targets: [
      .target(name: "Slp2_Project", dependencies: ["RxMoya", "ReactiveMoya"])
   ]
)
