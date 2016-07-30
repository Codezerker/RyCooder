import PackageDescription

let package = Package(
  name: "RyCooder",
  dependencies: [
    .Package(url: "https://github.com/Codezerker/Leonid.git", majorVersion: 1),
  ]
)

