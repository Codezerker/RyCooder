# RyCooder
Simple command line music player written in Swift.

## How to install RyCooder

If you have __Xcode 7.0 or above__ installed, and you are using the Xcode version of Swift 2.x, you can build RyCooder yourself. If not, you can download pre-compiled binary.

### Build RyCooder yourself
```
git clone git@github.com:Codezerker/RyCooder.git
cd RyCooder
./install
```

### Use pre-compiled versions
You can download pre-compiled binaries [here](https://github.com/Codezerker/RyCooder/releases).

## How to use RyCooder

You can listen to your favorite music in command line by simply run `rycooder` in the folder that contains music files.

```
cd /Path/To/Music/Files
rycooder
```

When you run `rycooder` in any folder, it will add all the music files in the current folder and all its subfolders in the playing queue. RyCooder regards only `.mp3` and `.m4a` files as _music files_ currently.
