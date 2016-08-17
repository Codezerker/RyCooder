import Foundation
import AVFoundation

internal protocol EventHandling {

  func handle(event: EventLoop.Event?)
}

internal class EventLoop: NSObject {

  internal enum Event {
    case start
    case playNext
    case playPrevious
    case toggleShuffle
    case jumpToItem(index: Int)
    case itemFinishedPlaying(item: AVPlayerItem)

    private static let inputMap: [String : Event] = [
      "s"        : .start,
      "start"    : .start,

      "n"        : .playNext,
      "next"     : .playNext,

      "p"        : .playPrevious,
      "previous" : .playPrevious,

      "shuffle"  : .toggleShuffle,
    ]

    fileprivate init?(withInput input: String) {
      if let index = Int(input) {
        self = .jumpToItem(index: index - 1)
      } else {
        guard let value = Event.inputMap[input] else {
          return nil
        }
        self = value
      }
    }
  }

  private let runLoop = RunLoop.current
  fileprivate var handler: EventHandling?
  fileprivate let standardInputFileHandle = FileHandle.standardInput

  internal func start(withHandler handler: EventHandling) {
    self.handler = handler
    readFromStandardInputAndWait()
    NotificationCenter.default.addObserver(forName: .NSFileHandleDataAvailable, object: nil, queue: OperationQueue.main) { [weak self] _ in
      self?.readFromStandardInputAndWait()
    }
    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { [weak self] notification in
      self?.playerItemDidFinishPlaying(notification)
    }
    runLoop.run()
  }
}

extension EventLoop {

  @objc fileprivate func readFromStandardInputAndWait() {
    defer {
      standardInputFileHandle.waitForDataInBackgroundAndNotify()
    }

    guard let input = NSString(data: standardInputFileHandle.availableData, encoding: String.Encoding.utf8.rawValue)?.replacingOccurrences(of: "\n", with: "") else {
      return
    }
    let event = Event(withInput: input)
    handler?.handle(event: event)
  }

  @objc fileprivate func playerItemDidFinishPlaying(_ notification: Notification) {
    guard let item = notification.object as? AVPlayerItem else {
      return
    }
    handler?.handle(event: .itemFinishedPlaying(item: item))
  }
}


