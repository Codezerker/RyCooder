import Foundation

internal extension FileManager {
  
  internal func filteredMusicFileURLs(inDirectory directory: String) -> [NSURL] {
    guard let dir = URL(string: directory),
          let enumerator = enumerator(at: dir, includingPropertiesForKeys: nil, options: [], errorHandler: nil) else {
      return []
    }

    var musicFiles = [URL]()
    let enumeration: () -> Bool = {
      guard let fileURL = enumerator.nextObject() as? URL else {
        return false
      }
      if fileURL.isMusicFile {
        musicFiles.append(fileURL)
        return true 
      } else {
        return true
      }
    }
    while enumeration() {}
    return musicFiles
  }
}

internal extension URL {

  private enum MusicFileExtension: String {
    case mp3 = "mp3"
    case m4a = "m4a"
    case m4p = "m4p"
  }

  internal var isMusicFile: Bool {
    guard let pathExtension = pathExtension else {
      return false
    }
    return MusicFileExtension(rawValue: pathExtension) != nil
  }
}

