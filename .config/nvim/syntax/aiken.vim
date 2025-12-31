" Vim syntax file for Aiken
" Language: Aiken
" Maintainer: Auto-generated

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword aikenKeyword use validator fn let when is if else and or trace expect
syn keyword aikenType Bool Int ByteArray Data Void List Pairs String Option
syn keyword aikenBoolean True False
syn keyword aikenConditional if else when is
syn keyword aikenRepeat use
syn keyword aikenFunction fn validator

" Comments
syn match aikenComment "//.*$"
syn region aikenBlockComment start="/\*" end="\*/"

" Strings
syn region aikenString start='"' end='"' skip='\\"'

" Numbers
syn match aikenNumber '\d\+'
syn match aikenNumber '0[xX][0-9a-fA-F]\+'

" Operators
syn match aikenOperator "==\|!=\|<=\|>=\|<\|>\|+\|-\|\*\|/\|%\|&&\|||\|!"

" Type annotations
syn match aikenType "[A-Z][a-zA-Z0-9_]*"

" Function names
syn match aikenFunction "\<fn\s\+\w\+"

" Highlighting
hi def link aikenKeyword Keyword
hi def link aikenType Type
hi def link aikenBoolean Boolean
hi def link aikenConditional Conditional
hi def link aikenRepeat Repeat
hi def link aikenFunction Function
hi def link aikenComment Comment
hi def link aikenBlockComment Comment
hi def link aikenString String
hi def link aikenNumber Number
hi def link aikenOperator Operator

let b:current_syntax = "aiken"
