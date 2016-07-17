import Foundation

internal protocol PlayerDisplayController {
  
  func playerDidFinishLoading(audioFiles: [URL])
}

internal struct PlayerLogger: PlayerDisplayController {
  
  internal func playerDidFinishLoading(audioFiles: [URL]) {
    AudioFileLoadingView(audioFiles: audioFiles).display()
    StartingView().display()
  }
}

