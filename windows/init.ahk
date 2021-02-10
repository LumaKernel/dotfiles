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
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Left}
}
return

!j::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Down}
}
return

!k::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Up}
}
return

!l::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Right}
}
return

; Alt + Shift + hjkl

!+h::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Shift Down}{Left}{Shift Up}
}
return

!+j::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Shift Down}{Down}{Shift Up}
}
return

!+k::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Shift Down}{Up}{Shift Up}
}
return

!+l::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Shift Down}{Right}{Shift Up}
}
return

; Alt + Ctrl + hjkl

!^h::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Ctrl Down}{Left}{Ctrl Up}
}
return

!^j::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Ctrl Down}{Down}{Ctrl Up}
}
return

!^k::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Ctrl Down}{Up}{Ctrl Up}
}
return

!^l::
WinGetActiveTitle, Title
if Title != WSL
{
  Send, {Ctrl Down}{Right}{Ctrl Up}
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
