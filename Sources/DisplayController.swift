import Foundation
import AVFoundation

internal protocol PlayerDisplayController {
  
  func playerDidFinishLoading(audioFiles: [URL])
  func playerDidEncounterUnknownCommand(_ command: String)
  func playerDidStartPlayingItem(_ item: AVPlayerItem)
}

internal struct PlayerLogger: PlayerDisplayController {
  
  internal func playerDidFinishLoading(audioFiles: [URL]) {
    AudioFileLoadingView(audioFiles: audioFiles).display()
    StartingView().display()
  }

  internal func playerDidEncounterUnknownCommand(_ command: String) {
    UnknownCommandView().display()
  }

  internal func playerDidStartPlayingItem(_ item: AVPlayerItem) {
    StartPlayingView(item: item).display()
  }
}

