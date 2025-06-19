alias wine32='WINEARCH=win32 WINEPREFIX=~/.win32 wine'
alias wine64='WINEARCH=win64 WINEPREFIX=~/.win64 wine'
win32() {
    export WINEARCH=win32
    export WINEPREFIX=~/.win32
}
win64() {
    export WINEARCH=win64
    export WINEPREFIX=~/.win64
}
