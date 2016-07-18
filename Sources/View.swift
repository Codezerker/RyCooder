import Foundation
import AVFoundation

internal protocol Displayable {
  
  func display()
}

internal struct AudioFileLoadingView: Displayable {
  
  private let audioFiles: [URL]

  internal init(audioFiles: [URL]) {
    self.audioFiles = audioFiles
  }
  
  internal func display() {
    print("🎵  Audio Files added to playlist:")
    for (index, audioFile) in audioFiles.enumerated() {
      guard let filename = audioFile.lastPathComponent else {
        continue
      }
      print("#\(index + 1) - \(filename)")
    }
  }
}

internal struct StartingView: Displayable {
  
  internal func display() {
    print("\n===== Type \"(s)tart\" to start playing.")
    print("===== Type \"(n)ext\" or \"(p)revious\" to change a song.")
    print("===== Type index to select a song.")
    print("===== Type \"shuffle\" to toggle song shuffling.")
  }
}

internal struct UnknownCommandView: Displayable {
 
  internal func display() {
    print("\nUnrecognized command 😦 .")
  }
}

internal struct StartPlayingView: Displayable {
  
  internal func display() {
    print("\n=====> 🎵  RyCooder has taken the stage...")
  }
}

internal struct ItemPlayingView: Displayable {

  private let item: AVPlayerItem

  internal init(item: AVPlayerItem) {
    self.item = item
  }

  internal func display() {
    guard let asset = item.asset as? AVURLAsset,
          let filename = asset.url.lastPathComponent else {
      return
    }
    print("\n=====> Now playing: \(filename)")
  }
}

internal struct ShuffleView: Displayable {

  private let shuffle: Bool

  internal init(shuffle: Bool) {
    self.shuffle = shuffle
  }

  internal func display() {
    print("\n 🎭 shuffle: \(shuffle ? "ON" : "OFF")")
  }
}

