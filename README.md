# RyCooder
Simple command line music player written in Swift.

![](./Assets/demo.gif)

## Requirements

- macOS 10.11.5 (El Capitan)
- `swift-DEVELOPMENT-SNAPSHOT-2016-07-29-a`

See: https://swift.org/download/#using-downloads

## How to install RyCooder

```
make install
```

## How to use RyCooder

You can listen to your favorite music in command line by simply run `rycooder` in the folder that contains music files.

```
cd /Path/To/Music/Files
rycooder
```

When you run `rycooder` in a folder, it will add all the music files founded in the current folder and all its subfolders to the playing queue. 

RyCooder regards only `.mp3`, `.m4a` and `.m4p` files as _music files_ currently.

