import AVFoundation
import Foundation

public struct Player {

  private let eventLoop = EventLoop()
  private let logger = PlayerLogger()
  private let player: AVQueuePlayer
  private let playerItems: [AVPlayerItem]

  private struct Status {
    var shuffle = false
    var shuffledItems: [AVPlayerItem]? = nil
    var currentIndex: Int? = nil
  }
  private var status = Status()

  public init(path: String) {
    let audioFiles = FileManager.default().filteredMusicFileURLs(inDirectory: path)
    playerItems = audioFiles.map { AVPlayerItem(url: $0) }
    player = AVQueuePlayer(items: playerItems)
    logger.playerDidFinishLoading(audioFiles: audioFiles)
  }

  public func start() {
    eventLoop.start(withHandler: self)
  }
}

extension Player: EventHandling {

  func handle(event: EventLoop.Event?) {
    print(event)
  }
}

