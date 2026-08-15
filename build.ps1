if($IsWindows) 
{
    $cmd1 = Get-Command nasm.exe -ErrorAction SilentlyContinue
    $cmd2 = Get-Command qemu-system-i386.exe -ErrorAction SilentlyContinue
}

else
{
    $cmd1 = Get-Command nasm -ErrorAction SilentlyContinue
    $cmd2 = Get-Command qemu-system-i386 -ErrorAction SilentlyContinue
}

if($null -eq $cmd1)
{
    Write-host "installing nasm"
    if($IsLinux) 
    {
        sudo apt install nasm
    }

    elseif($IsMacOS) 
    {
        brew install nasm
    }

    elseif($IsWindows) 
    {
        winget install NASM.NASM
    }
}

if($null -eq $cmd2) 
{
    Write-host "installing qemu"
    if($IsLinux) 
    {
        sudo apt install qemu-system-x86
    }

    elseif($IsMacOS) 
    {
        brew install qemu
    }

    elseif($IsWindows) 
    {
        winget install SoftwareFreedomConservancy.QEMU
    }
}


if($null -ne $cmd1 -and $null -ne $cmd2) 
{
    Write-host "compiling"
    nasm -f bin hello.asm -o hello.bin

    if($LASTEXITCODE -eq 0) 
    {
        qemu-system-i386 -machine pc-i440fx-resolute,pcspk-audiodev=snd0 `
	    -drive format=raw,file=hello.bin `
	    -audiodev pa,id=snd0 
    }

    else 
    {
        Write-Error "ERROR"
    }
}