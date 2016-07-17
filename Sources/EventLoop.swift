import Foundation

internal protocol EventHandling {
  
  func handle(event: EventLoop.Event)
}

internal class EventLoop: NSObject {

  internal enum Event {
    case start
    case playNext
    case playPrevious
    case toggleShuffle
    case jumpToItem(index: Int)

    private static let inputMap: [String : Event] = [
      "s"        : .start,
      "start"    : .start,

      "n"        : .playNext,
      "next"     : .playNext,

      "p"        : .playPrevious,
      "previous" : .playPrevious,

      "shuffle"  : .toggleShuffle,
    ] 

    private static func event(withInput input: String) -> Event? {
      if let index = Int(input) {
        return .jumpToItem(index: index - 1)
      } else {
        return inputMap[input] 
      }
    }
  }

  private var handler: EventHandling?
  private let runLoop = RunLoop.current()
  private let standardInputFileHandle = FileHandle.standardInput()

  internal func start(withHandler handler: EventHandling) {
    self.handler = handler
  }
}

