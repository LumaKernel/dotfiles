#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



^h::
Send, {Backspace}
return

^m::
Send, {Enter}
return

^i::
Send, {Tab}
return

^[::
Send, {Escape}
return

; Alt + hjkl

!h::
IfWinActive, WSL
{
  Send, {!h}
}
else
{
  Send, {Left}
}
return

!j::
IfWinActive, WSL
{
  Send, {!j}
}
else
{
  Send, {Down}
}
return

!k::
IfWinActive, WSL
{
  Send, {!k}
}
else
{
  Send, {Up}
}
return

!l::
IfWinActive, WSL
{
  Send, {!l}
}
else
{
  Send, {Right}
}
return

; Alt + Shift + hjkl

!+h::
IfWinActive, WSL
{
  Send, {!+h}
}
else
{
  Send, {+Left}
}
return

!+j::
IfWinActive, WSL
{
  Send, {!+j}
}
else
{
  Send, {+Down}
}
return

!+k::
IfWinActive, WSL
{
  Send, {!+k}
}
else
{
  Send, {+Up}
}
return

!+l::
IfWinActive, WSL
{
  Send, {!+l}
}
else
{
  Send, {+Right}
}
return

; Alt + Ctrl + hjkl

!^h::
IfWinActive, WSL
{
  Send, {!^h}
}
else
{
  Send, {^Left}
}
return

!^j::
IfWinActive, WSL
{
  Send, {!^j}
}
else
{
  Send, {^Down}
}
return

!^k::
IfWinActive, WSL
{
  Send, {!^k}
}
else
{
  Send, {^Up}
}
return

!^l::
IfWinActive, WSL
{
  Send, {!^l}
}
else
{
  Send, {^Right}
}
return

vk1D & b::
Send, {Left}
return

vk1D & f::
Send, {Right}
return

vk1D & n::
Send, {Down}
return

vk1D & p::
Send, {Up}
return

vk1D & a::
Send, {Home}
return

vk1D & e::
Send, {End}
return

vk1D & h::
Send, {Backspace}
return

vk1D & d::
Send, {Delete}
return

vk1D & m::
Send, {Enter}
return

vk1D & u::
Send, {Ctrl Down}{Backspace}{Ctrl Up}
return
