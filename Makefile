.PHONY: build
build:
	mkdir -p build
	cd src && zip -9 -r ../build/snake.love .

run:
	cd src && love .
