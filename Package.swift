import PackageDescription

let package = Package(
  name: "RyCooder",
  dependencies: [
    .Package(url: "https://github.com/apple/example-package-fisheryates.git", majorVersion: 1),
  ]
)

