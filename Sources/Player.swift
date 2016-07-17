import AVFoundation
import Foundation

public struct Player {
  
  private let player: AVQueuePlayer
  private let playerItems: [AVPlayerItem]

  private struct Status {
    var shuffle = false
    var currentIndex: Int? = nil
  }
  private var status = Status()

  public init(path: String) {
    playerItems = FileManager.default()
      .filteredMusicFileURLs(inDirectory: path)
      .map { AVPlayerItem(url: $0) }
    player = AVQueuePlayer(items: playerItems)
  }

  public func start() {
    // FIXME:
  }
}

