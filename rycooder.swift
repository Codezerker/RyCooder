import Foundation
import AVFoundation

struct RyCooder {

    private let runLoop = NSRunLoop.currentRunLoop()
    private let stdinHandle = NSFileHandle.fileHandleWithStandardInput()
    private let songs: [AVPlayerItem]
    private let player: AVQueuePlayer

    init(pathToStage: String) {
        let musicFiles = RyCooder.musicFilesInDirectory(pathToStage)
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
        runLoop.run()
    }

}

extension RyCooder {

    private func handleInput() {
        guard let inputString = NSString(data: stdinHandle.availableData, encoding: NSUTF8StringEncoding) else {
            return
        }

        let input = inputString.stringByReplacingOccurrencesOfString("\n", withString:"")

        if let inputNumber = Int(input) {
            if inputNumber > 0 && inputNumber <= songs.count {
                jumpToSongAtIndex(inputNumber - 1)
                player.play()
            }

            return
        } else {
            switch input {
            case "start":
                logStart()
                player.play()
            case "n", "next":
                player.advanceToNextItem()
                player.play()
            case "p", "previous":
                jumpToPreviousSong()
                player.play()
            default:
                print("Unrecognized command \"\(input)\" 😦 .")
            }

            stdinHandle.waitForDataInBackgroundAndNotify()
            logInputTips()
        }
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
    }

    private func jumpToPreviousSong() {
        print("WIP")    
    }

    private func logStart() {
        print("\n=====> 🎵  RyCooder has taken the stage...")
    }

    private func logInputTips() {
        print("\nType \"(n)ext\" or \"(p)revious\" to change song.")
        print("Type index number to play that song.")
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
            guard let fileURL = directoryEnumerator.nextObject() as? NSURL where fileURL.musicFile,
                  let fileName = fileURL.lastPathComponent else {
                return false
            }

            let fullURL = dirURL.URLByAppendingPathComponent(fileName) 
            result.append(fullURL)
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
        print("\n===== Type \"start\" to begin.")
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

