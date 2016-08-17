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
    print("\(String.arrow) 🎵  files added to playlist:")
    for (index, audioFile) in audioFiles.enumerated() {
      let filename = audioFile.lastPathComponent
      let indexString = "#\(index + 1)".underlined
      print("\(indexString) - \(filename)")
    }
    print("")
  }
}

internal struct StartingView: Displayable {

  internal func display() {
    print("\(String.arrow) Type \("start".highlighted) to start playing.")
    print("\(String.arrow) Type \("next".highlighted) or \("previous".highlighted) to change songs.")
    print("\(String.arrow) Type \("index of a song".underlined) to jump to the song.")
    print("\(String.arrow) Type \("shuffle".highlighted) to toggle shuffling.")
    print("")
  }
}

internal struct UnknownCommandView: Displayable {

  internal func display() {
    print("\(String.arrow) Unrecognized command 😦 .")
  }
}

internal struct StartPlayingView: Displayable {

  internal func display() {
    print("\(String.arrow) 🎵  RyCooder has taken the stage...")
  }
}

internal struct ItemPlayingView: Displayable {

  private let item: AVPlayerItem

  internal init(item: AVPlayerItem) {
    self.item = item
  }

  internal func display() {
    guard let asset = item.asset as? AVURLAsset else{
      return
    }
    let filename = asset.url.lastPathComponent
    print("\n\(String.arrow) Now playing: \(filename.tinted)")
  }
}

internal struct ShuffleView: Displayable {

  private let shuffle: Bool

  internal init(shuffle: Bool) {
    self.shuffle = shuffle
  }

  internal func display() {
    print("\(String.arrow) 🎭  Shuffle turned \(shuffle ? "ON".turnedOn : "OFF".turnedOff).")
  }
}

