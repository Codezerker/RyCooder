import AVFoundation
import Foundation

public struct Player {

  private let eventLoop = EventLoop()
  private let logger = PlayerLogger()
  private let player: AVQueuePlayer
  private let items: [AVPlayerItem]

  private struct Status {
    var shuffledItems: [AVPlayerItem]? = nil
    var currentIndex: Int? = nil
  }
  private var status = Status()

  public init(path: String) {
    let audioFiles = FileManager.default().filteredMusicFileURLs(inDirectory: path)
    items = audioFiles.map { AVPlayerItem(url: $0) }
    player = AVQueuePlayer(items: items)
    logger.playerDidFinishLoading(audioFiles: audioFiles)
  }

  public func start() {
    eventLoop.start(withHandler: self)
  }
}

extension Player: EventHandling {

  func handle(event: EventLoop.Event?) {
    guard let event = event else {
      UnknownCommandView().display()
      return
    }
    
    switch event {
    case .start:
      guard player.rate == 0 else {
        return
      }
      jump(toIndex: 0)   
    
    case .playNext:
      break

    case .playPrevious:
      break

    case .toggleShuffle:
      break

    case .jumpToItem(let index):
      break

    case .itemFinishedPlaying(let item):
      break
    }
  }
}

private extension Player {
  
  private func jump(toIndex index: Int) {
    refill()
    for _ in 0..<index {
      player.advanceToNextItem()
    }
    player.play()
    StartPlayingView(item: player.currentItem)?.display()
  }

  private func refill() {
    player.removeAllItems()
    let items = itemsForPlay
    for item in items {
      item.seek(to: kCMTimeZero)
      player.insert(item, after: nil)
    }
  }

  private var itemsForPlay: [AVPlayerItem] {
    if let shuffledItems = status.shuffledItems {
      return shuffledItems
    } else {
      return items
    }
  }
}

