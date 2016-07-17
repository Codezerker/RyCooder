run:
	swift build
	lldb .build/debug/RyCooder

install:
	swift build
	cp .build/debug/RyCooder /usr/local/bin/rycooder

clean:
	rm -rf .build/

