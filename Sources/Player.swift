import AVFoundation
import Foundation

public struct Player {

  fileprivate let eventLoop = EventLoop()
  fileprivate let logger = PlayerLogger()
  fileprivate let player: AVQueuePlayer
  fileprivate let items: [AVPlayerItem]

  fileprivate class Status {
    var shuffledItems: [AVPlayerItem]? = nil
    var currentIndex: Int? = nil
  }
  fileprivate let status = Status()

  public init(path: String) {
    let audioFiles = FileManager.default.filteredMusicFileURLs(inDirectory: path)
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
      logger.playerDidEncounterUnknownCommand("")
      return
    }
    
    switch event {
    case .start:
      guard player.rate == 0 else {
        return
      }
      logger.playerDidStartPlayBack()
      jump(toIndex: 0)   
    case .playNext:
      guard let currentIndex = status.currentIndex else {
        return
      }
      jump(toIndex: currentIndex + 1)
    case .playPrevious:
      guard let currentIndex = status.currentIndex else {
        return
      }
      jump(toIndex: currentIndex - 1)
    case .toggleShuffle:
      if status.shuffledItems != nil {
        status.shuffledItems = nil
        logger.playerDidToggleShuffle(shuffle: false)
      } else {
        status.shuffledItems = items.shuffled()
        logger.playerDidToggleShuffle(shuffle: true)
      }
    case .jumpToItem(let index):
      jump(toIndex: index)
    case .itemFinishedPlaying(let item):
      guard let index = itemsForPlay.index(of: item) else {
        return
      }
      jump(toIndex: index + 1)
    }
  }
}

fileprivate extension Player {
  
  fileprivate func jump(toIndex index: Int) {
    var indexForPlay = index
    if indexForPlay < 0 {
      indexForPlay = itemsForPlay.count - 1
    }
    if indexForPlay >= itemsForPlay.count {
      indexForPlay = 0
    }

    refill()
    for _ in 0..<indexForPlay {
      player.advanceToNextItem()
    }
    player.play()
    status.currentIndex = indexForPlay
    if let currentItem = player.currentItem {
      logger.playerDidStartPlayingItem(currentItem)
    }
  }

  private func refill() {
    player.removeAllItems()
    let items = itemsForPlay
    for item in items {
      item.seek(to: kCMTimeZero)
      player.insert(item, after: nil)
    }
  }

  fileprivate var itemsForPlay: [AVPlayerItem] {
    if let shuffledItems = status.shuffledItems {
      return shuffledItems
    } else {
      return items
    }
  }
}

