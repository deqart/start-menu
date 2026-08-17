default:
	cmake -S . -B build -DCMAKE_INSTALL_PREFIX=~/.local
	cmake --build build

install: default
	cmake --install build

clean:
	rm -rf build

.PHONY: default install clean
