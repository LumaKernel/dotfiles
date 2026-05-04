" Vim syntax file
" Language: MoonBit
" Maintainer: luma

if exists('b:current_syntax')
  finish
endif

" Keywords
syn keyword moonbitConditional if else match guard is
syn keyword moonbitRepeat while loop break continue
syn match   moonbitRepeat /\<for\>/
syn keyword moonbitKeyword fn let mut pub priv readonly
syn keyword moonbitKeyword struct enum type typealias trait impl derive
syn keyword moonbitKeyword return as
syn keyword moonbitKeyword try catch raise
syn keyword moonbitKeyword test init
syn keyword moonbitKeyword async await
syn keyword moonbitStorage const

" Boolean
syn keyword moonbitBoolean true false

" Builtin types
syn keyword moonbitType Int Int64 UInt UInt64 Float Double String Char Bool Byte Unit
syn keyword moonbitType Array Map Option Result Error Self

" Numbers
syn match moonbitNumber "\<\d\+\>"
syn match moonbitNumber "\<0[xX][0-9a-fA-F]\+\>"
syn match moonbitNumber "\<0[oO][0-7]\+\>"
syn match moonbitNumber "\<0[bB][01]\+\>"
syn match moonbitFloat "\<\d\+\.\d*\>"

" Char
syn region moonbitChar start="'" skip="\\'" end="'"

" Strings
syn region moonbitString start='"' skip='\\"' end='"' contains=moonbitEscape,moonbitInterp
syn region moonbitMultiString start='#|' end='$'
syn match moonbitEscape "\\[nrt\\\"0]" contained
syn match moonbitInterp "\\{[^}]*}" contained

" Operators
syn match moonbitOperator "[+\-*/%<>=!&|^~?]"
syn match moonbitOperator "->"
syn match moonbitOperator "=>"
syn match moonbitOperator "|>"
syn match moonbitOperator "::"

" Attributes
syn match moonbitAttribute "#\[.\{-}\]"

" Comments (must be after keywords so they take priority)
syn region moonbitLineComment    start="//"  end="$" contains=moonbitTodo,@Spell
syn region moonbitDocComment     start="///" end="$" contains=moonbitTodo,@Spell
syn keyword moonbitTodo TODO FIXME XXX NOTE contained

" Highlights
hi def link moonbitConditional Conditional
hi def link moonbitRepeat      Repeat
hi def link moonbitKeyword     Keyword
hi def link moonbitStorage     StorageClass
hi def link moonbitBoolean     Boolean
hi def link moonbitType        Type
hi def link moonbitNumber      Number
hi def link moonbitFloat       Float
hi def link moonbitChar        Character
hi def link moonbitString      String
hi def link moonbitMultiString String
hi def link moonbitEscape      SpecialChar
hi def link moonbitInterp      Special
hi def link moonbitOperator    Operator
hi def link moonbitAttribute   PreProc
hi def link moonbitLineComment Comment
hi def link moonbitDocComment  SpecialComment
hi def link moonbitTodo        Todo

let b:current_syntax = 'moonbit'
