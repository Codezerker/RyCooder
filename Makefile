run:
	swift build
	lldb .build/debug/RyCooder

install:
	swift build -c release
	cp .build/debug/RyCooder /usr/local/bin/rycooder

clean:
	rm -rf .build/

