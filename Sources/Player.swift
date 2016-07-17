import AVFoundation
import Foundation

public struct Player {
  
  //private let musicFileURLs: [NSURL]
  //private let player: AVQueuePlayer
  //private let playerItems: [AVPlayerItem]

  private struct Status {
    var shuffle = false
    var currentIndex: Int? = nil
  }
  private var status = Status()

  public init(path: String) {

  }

  public func start() {
    // FIXME:
  }
}

