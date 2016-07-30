import Foundation

let workingDirectory = FileManager.default.currentDirectoryPath
let player = Player(path: workingDirectory)
player.start()

