; # - Windows Key
; ^ - Ctrl
; ! - Alt
; + - Shift

;Always on Top

^SPACE::  Winset, Alwaysontop, , A

;Shortcut for Apps I frequently used

!Q::Run "C:\Users\Admin\Desktop\Sticky Notes.lnk"

;Media Keys

+Space::Send       {Media_Play_Pause}
+LCtrl::Send        {Media_Prev}
+LAlt::Send       {Media_Next}

;Volume Control

!WheelDown::Volume_Down
!WheelUp::Volume_Up
!F7::Volume_Mute

;Next and Previous Windows

^F9::Send !{Tab}							

;Switch Desktop

;#LAlt::^#Right 
;#LCtrl::^#Left 

;Search Selected

^+c::
{
 Send, ^c
 Sleep 50
 Run, https://www.google.com/search?q=%clipboard%
 Return
}

;Mouse and Keyboard Remapping (Right Click)

;RAlt::RButton
;Rwin::Down
;Rwin::+Enter


;Sleep the pc
^!m::
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
Return


