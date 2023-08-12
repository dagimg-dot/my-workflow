; Autohotkey Capslock Remapping Script 

; Functionality:
; - Deactivates capslock for normal (accidental) use.
; - Access the following functions when pressing Capslock:
;     Switch Desktop        - 2, 3  
;     Cursor keys           - J, K, L, I
;     Enter                 - Space
;     Ctrl                  - E
;     Home, PgDn, PgUp, End - U, O, Y, H
;     Backspace and Del     - N, M
;
;     Select all            - A
;     Cut, copy, paste      - S, D, F
;     Close tab, window     - W, X
;     Esc                   - R
;     Next, previous tab    - Tab, Q
;     Undo, redo            - , and .
;     \                     - /
;
;     For Browsers
; 
;     New Tab               - T
;     Home                  - V
;     New                   - N
;  
; To use capslock as you normally would, you can press Winkey + Capslock





#Persistent
SetCapsLockState, AlwaysOff

; Capslock + 2 and 3 (Desktop switching)

Capslock & 2::SendInput {CtrlDown}{LWinDown}{Left}
Capslock & 2 up::SendInput {CtrlUp}{LWinUp}}{Left Up}
Capslock & 3::SendInput {CtrlDown}{LWinDown}{Right}
Capslock & 3 up::SendInput {CtrlUp}{LWinUp}}{Right Up}

; Capslock + jkli (left, down, up, right)

Capslock & j::Send {Blind}{Left DownTemp}
Capslock & j up::Send {Blind}{Left Up}

Capslock & k::Send {Blind}{Down DownTemp}
Capslock & k up::Send {Blind}{Down Up}

Capslock & i::Send {Blind}{Up DownTemp}
Capslock & i up::Send {Blind}{Up Up}

Capslock & l::Send {Blind}{Right DownTemp}
Capslock & l up::Send {Blind}{Right Up}

; Capslock + e + (for Ctrl key)

Capslock & e::SendInput {Blind}{Ctrl Down}
Capslock & e up::SendInput {Blind}{Ctrl Up}

; Capslock + b,' (for VS Code)

Capslock & b::SendInput {Blind}{Ctrl Down}{Shift Down}
Capslock & b up::SendInput {Blind}{Ctrl Up}{Shift Up}
Capslock & '::SendInput {Blind}{Ctrl Down}{Shift Down}{e Down}
Capslock & ' up::SendInput {Blind}{Ctrl Up}{Shift Up}{e Up}

; Map CapsLock + = to Alt + Left Arrow
CapsLock & =::SendInput {Alt Down}{Left Down}
CapsLock & = up::SendInput {Alt Up}{Left Up}

; Capslock + uohy (pgdown, pgup, home, end)

Capslock & u::SendInput {Blind}{Home Down}
Capslock & u up::SendInput {Blind}{Home Up}

Capslock & o::SendInput {Blind}{End Down}
Capslock & o up::SendInput {Blind}{End Up}

Capslock & y::SendInput {Blind}{PgUp Down}
Capslock & y up::SendInput {Blind}{PgUp Up}

Capslock & h::SendInput {Blind}{PgDn Down}
Capslock & h up::SendInput {Blind}{PgDn Up}


; Capslock + asdf (select all, cut-copy-paste)

Capslock & a::SendInput {Ctrl Down}{a Down}
Capslock & a up::SendInput {Ctrl Up}{a Up}

Capslock & s::SendInput {Ctrl Down}{x Down}
Capslock & s up::SendInput {Ctrl Up}{x Up}

Capslock & d::SendInput {Ctrl Down}{c Down}
Capslock & d up::SendInput {Ctrl Up}{c Up}

Capslock & f::SendInput {Ctrl Down}{v Down}
Capslock & f up::SendInput {Ctrl Up}{v Up}


; Capslock + wxr (close tab or window, press esc)

Capslock & w::SendInput {Ctrl down}{w down}{Ctrl up}{w up}
Capslock & x::SendInput {Alt down}{F4}{Alt up}{Ctrl up}{F4 up}
Capslock & r::SendInput {Blind}{Esc Down}{Esc Up}


; Capslock + nm (insert, backspace, del)

Capslock & m::SendInput {Blind}{Del Down}
Capslock & n::SendInput {Blind}{BS Down}
Capslock & BS::SendInput {Blind}{BS Down}
;Capslock & b::SendInput {Blind}{Insert Down}

; Capslock + /pt (Personal Use)

Capslock & /::SendInput {Blind}{\ Down}
Capslock & / up::SendInput {Blind}{\ Up}
Capslock & v::SendInput {Blind}{Alt Down}{Home Down}
Capslock & v up::SendInput {Blind}{Alt up}{Home Up}
Capslock & t::SendInput {Blind}{Ctrl Down}{t Down}
Capslock & t up::SendInput {Blind}{Ctrl up}{t Up}
Capslock & g::SendInput {Blind}{Ctrl Down}{n Down}
Capslock & g up::SendInput {Blind}{Ctrl up}{n Up}
Capslock & c::SendInput {Blind}{Del Down}
Capslock & ]:: Send, {U+223C} 
Capslock & [:: Send, {U+0060}
Capslock & 9:: Send, {F8}
Capslock & 8:: Send, {F5}
Capslock & 0:: SendInput {Blind}{Ctrl Down}{f Down}
Capslock & 0 up:: SendInput {Blind}{Ctrl up}{f Up}
;return

; Map Caps Lock + - to four space clicks

CapsLock & -::
    SendInput {Space 4}
return


; Make Capslock & Enter equivalent to Control+Enter
;Capslock & Enter::SendInput {Ctrl down}{Enter}{Ctrl up}


; Make Capslock & Alt Equivalent to Control+Alt
; !Capslock::SendInput {Ctrl down}{Alt Down}
; !Capslock up::SendInput {Ctrl up}{Alt up}


; Capslock + TAB/q (prev/next tab)

Capslock & q::SendInput {Ctrl Down}{Tab Down}
Capslock & q up::SendInput {Ctrl Up}{Tab Up}
Capslock & Tab::SendInput {Ctrl Down}{Shift Down}{Tab Down}
Capslock & Tab up::SendInput {Ctrl Up}{Shift Up}{Tab Up}

; Capslock + ,/. (undo/redo)

Capslock & ,::SendInput {Ctrl Down}{z Down}
Capslock & , up::SendInput {Ctrl Up}{z Up}
Capslock & .::SendInput {Ctrl Down}{y Down}
Capslock & . up::SendInput {Ctrl Up}{y Up}


; Make Capslock+Space -> Enter

Capslock & Space::SendInput {Enter Down}
Capslock & Space Up::SendInput {Enter Up}

; Make Win Key + Capslock work like Capslock (in case it's ever needed)
#Capslock::
If GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, AlwaysOff
Else 
    SetCapsLockState, AlwaysOn
Return
