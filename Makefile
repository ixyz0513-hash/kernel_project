all: hello.bin

hello.bin: hello.asm
	nasm -f bin hello.asm -o hello.bin

run: hello.bin
	qemu-system-i386 -drive format=raw,file=hello.bin -display sdl,window-close=on