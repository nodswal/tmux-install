CoordMode, pixel, Screen
CoordMode, mouse, screen

; fget, fspleef, fchicatrice, fjump
; fspleef()
fjump()


fget()
{
    PixelGetColor, OutputVar, 840, -240 , alt

    MsgBox, 0, "PixelGetColor", %OutputVar%, 5
    Sleep, 7000

    Exit, 3
}

fspleef()
{
; get to spleef circle
    MouseClick, left, 991, -448

    Sleep, 2000

    send, {w down}
    sleep, 1500
    send, {w up}

    send, {a down}
    sleep, 3000
    send, {a up}

    ; if 0x782e4d at 840, -240,  need to move up to circle for chicatrice

    Exit, 0
}

fjump()
{
; jump, keep from disconnecting
MouseClick, left, 991, -448
Sleep, 4000

Send, {space}
Sleep, 1000

Send, {space}
Sleep, 66000

Send, {space}
Sleep, 1000

Send, {space}
Sleep, 86000


Exit, 1
}




Exit, 0











PixelGetColor, OutputVar, 991, -448 , alt

MsgBox, 0, "PixelGetColor", %OutputVar%, 5


x := 0
a := 0

Loop {
    ToolTip, the loop: %a%, 300, -300
    MouseMove, 991, -448, 50
    Sleep, 3000
    MouseMove, 1004, -455, 50
    Sleep, 3000


    PixelSearch, OutputVarX, OutputVarY, 991, -448, 1004, -455, 0x55c64a , 10, alt
    if ErrorLevel
        x := 0
    else
        ; MsgBox, A color within 3 shades of variation was found at X%OutputVarX% Y%OutputVarY%.
        MouseClick, left, 991, -448
        Sleep, 5000
        send, {w down}
        sleep, 3000




    if ( x > 7 )
        Break

    Sleep, 7000

    a := %a% + 1
}