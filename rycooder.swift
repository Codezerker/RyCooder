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
        print(__FUNCTION__)
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

