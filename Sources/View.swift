import Foundation

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
  }
}

