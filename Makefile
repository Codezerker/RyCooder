.PHONY: run
.PHONY: install

run:
	swift build
	.build/debug/RyCooder

install:
	swift build
	cp .build/debug/RyCooder /usr/local/bin/rycooder

