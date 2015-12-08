import Foundation
import AVFoundation

class RyCooder {

  private let runLoop = NSRunLoop.currentRunLoop()
  private let stdinHandle = NSFileHandle.fileHandleWithStandardInput()
  private let musicFiles: [NSURL]
  private let songs: [AVPlayerItem]
  private let player: AVQueuePlayer

  private var currentSongIndex = 0

  init(pathToStage: String) {
    musicFiles = RyCooder.musicFilesInDirectory(pathToStage)
    songs = musicFiles.map { musicFileURL -> AVPlayerItem in
      return AVPlayerItem(URL: musicFileURL)
    }
    player = AVQueuePlayer(items: songs)

    printMusicFiles(musicFiles)
  }

  func start() {
    handleInput()
    NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification, 
                                         object: nil, 
                                         queue: NSOperationQueue.mainQueue()) { _ in
      self.handleInput()                           
    }

    NSNotificationCenter.defaultCenter().addObserverForName(AVPlayerItemDidPlayToEndTimeNotification,
                                         object: nil,
                                         queue: NSOperationQueue.mainQueue()) { notification in
      guard let song = notification.object as? AVPlayerItem,
      let index = self.songs.indexOf(song) else {
        return
      }

      let nextIndex = index + 1
      if nextIndex == self.songs.count {
        self.handlePlayBackFinishing()
      } else {
        self.currentSongIndex = nextIndex
        if let fileName = self.musicFiles[nextIndex].lastPathComponent {
          self.logStart(fileName)
        }
      }
    }
    runLoop.run()
  }

}

extension RyCooder {

  private func handleInput() {
    defer {
      stdinHandle.waitForDataInBackgroundAndNotify()
      logInputTips()
    }

    guard let inputString = NSString(data: stdinHandle.availableData, encoding: NSUTF8StringEncoding) else {
      return
    }

    let input = inputString.stringByReplacingOccurrencesOfString("\n", withString:"")

    if let inputNumber = Int(input) {
      if inputNumber > 0 && inputNumber <= songs.count {
        jumpToSongAtIndex(inputNumber - 1)
      }

      return
    } else {
      switch input {
      case "s", "start":
        guard player.rate == 0 else {
          return
        }

        print("\n=====> 🎵  RyCooder has taken the stage...")
        jumpToSongAtIndex(0)

      case "n", "next":
        var next = currentSongIndex + 1
        if next == songs.count {
          next = 0
        }

        jumpToSongAtIndex(next)

      case "p", "previous":
        var previous = currentSongIndex - 1
        if previous < 0 {
          previous = songs.count - 1
        }

        jumpToSongAtIndex(previous)

      default:
        print("Unrecognized command \"\(input)\" 😦 .")
      }
    }
  }

  private func handlePlayBackFinishing() {
    jumpToSongAtIndex(0)
  }

  private func jumpToSongAtIndex(index: Int) {
    player.removeAllItems()

    for song in songs {
      song.seekToTime(kCMTimeZero)
      player.insertItem(song, afterItem: nil)
    }

    for _ in 0..<index {
      player.advanceToNextItem()
    }

    player.play()

    currentSongIndex = index

    guard let fileName = musicFiles[index].lastPathComponent else {
      return
    }
    logStart(fileName)
  }

  private func jumpToPreviousSong() {
    guard currentSongIndex - 1 >= 0 else {
      return
    }

    let previous = currentSongIndex - 1
    jumpToSongAtIndex(previous)
  }

  private func logStart(nameOfSong: String) {
    print("\n=====> Now playing: \(nameOfSong)")
  }

  private func logInputTips() {
    print("\nType \"(n)ext\" or \"(p)revious\" to change a song.")
    print("Type index to select a song.")
  }

}

extension RyCooder {

  private static func musicFilesInDirectory(dirPath: String) -> [NSURL] {
    var result = [NSURL]()

    let dirURL = NSURL(fileURLWithPath: dirPath, isDirectory: false)
    guard let directoryEnumerator = NSFileManager.defaultManager().enumeratorAtURL(dirURL, 
              includingPropertiesForKeys: nil, options: [], errorHandler: nil) else {
      return result
    }

    let fileEnumeration: () -> Bool = {
      guard let fileURL = directoryEnumerator.nextObject() as? NSURL else {
        return false
      }

      guard fileURL.musicFile else {
        return true
      }

      result.append(fileURL)
      return true
    }

    while fileEnumeration() {}

    return result
  }

  private func printMusicFiles(musicFiles: [NSURL]) {
    print("Music added to player queue:")
    for (index, musicURL) in musicFiles.enumerate() {
      guard let fileName = musicURL.lastPathComponent else {
        continue
      }
      print("#\(index + 1) -  \(fileName)")
    }
    print("\n===== Type \"(s)tart\" to begin.")
  }

}

extension NSURL {

  private struct MusicFileExtensions {
    static let mp3 = "mp3"
    static let m4a = "m4a"
  }

  var musicFile: Bool {
    guard let pathExtension = pathExtension else {
      return false
    }

    switch pathExtension {
    case MusicFileExtensions.mp3, MusicFileExtensions.m4a:
      return true
    default:
      return false
    }
  }

}

// MARK: - Scripts
let path = NSFileManager.defaultManager().currentDirectoryPath
let rycooder = RyCooder(pathToStage: path)
rycooder.start()

