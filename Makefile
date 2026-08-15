
hello.bin: hello.asm
	nasm -f bin hello.asm -o hello.bin

run: hello.bin
	qemu-system-i386 -machine pc-i440fx-resolute,pcspk-audiodev=snd0 \
	-drive format=raw,file=hello.bin \
	-audiodev pa,id=snd0 