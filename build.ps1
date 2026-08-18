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
    Write-Error "Need to install nasm"
}

if($null -eq $cmd2) 
{
    Write-Error "Need to install qemu"
}


if($null -ne $cmd1 -and $null -ne $cmd2) 
{
    Write-host "Compiling" -ForegroundColor Yellow
    nasm -f bin hello.asm -o hello.bin

    if($LASTEXITCODE) 
    {
        Write-Error "ERROR"
    }

    else 
    {
        if($IsLinux) 
        {
            qemu-system-i386 -machine pc,pcspk-audiodev=snd0 `
	        -drive format=raw,file=hello.bin `
	        -audiodev pa,id=snd0 
        }
        elseif($IsMacOS) 
        {
            qemu-system-i386 -machine pc,pcspk-audiodev=snd0 `
	        -drive format=raw,file=hello.bin `
	        -audiodev coreaudio,id=snd0 
        }
        elseif($IsWindows) 
        {
            qemu-system-i386 -machine pc,pcspk-audiodev=snd0 `
	        -drive format=raw,file=hello.bin `
	        -audiodev dsound,id=snd0 
        }
    }
}