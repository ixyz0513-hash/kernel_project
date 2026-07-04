
hello.bin: hello.asm
	nasm -f bin hello.asm -o hello.bin

run: hello.bin
	qemu-system-i386 -machine pc-i440fx-resolute -drive format=raw,file=hello.bin \
  	-audiodev pa,id=snd0 \
  	-machine pcspk-audiodev=snd0 