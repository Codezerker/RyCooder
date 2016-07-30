import Foundation
import Leonid

internal extension FileManager {
  
  internal func filteredMusicFileURLs(inDirectory directory: String) -> [URL] {
    guard let enumerator = enumerator(at: URL(fileURLWithPath: directory), includingPropertiesForKeys: nil, options: [], errorHandler: nil) else {
      return []
    }

    var musicFiles = [URL]()
    let enumeration: () -> Bool = {
      guard let fileURL = enumerator.nextObject() as? URL else {
        return false
      }
      if fileURL.isMusicFile {
        musicFiles.append(fileURL)
      }
      return true
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
    return MusicFileExtension(rawValue: pathExtension) != nil
  }
}

internal extension String {

  internal static let arrow = "=====>".addingBash(color: .blue, style: .dim)

  internal var tinted: String {
    return addingBash(color: .blue, style: .none)
  }

  internal var turnedOn: String {
    return addingBash(color: .green, style: .none)
  }

  internal var turnedOff: String {
    return addingBash(color: .red, style: .dim)
  }

  internal var highlighted: String {
    return addingBash(color: .white, style: .bold)
  }

  internal var underlined: String {
    return addingBash(color: .white, style: .underline)
  }
}

