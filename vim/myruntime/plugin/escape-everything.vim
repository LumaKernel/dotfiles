" プラグイン化的なことをやるとして、これは vital プラグインになるのかな
" プラグイン化してちゃんとテストをしたい気持ちはある

" <f-args> として渡されたときに、str がそのままで解釈されるエスケープをする
function! EscapeFArgs(str) abort
  return escape(a:str, '\ ')
endfunction

" "D" stands for "Double quoted"
function! BashDStringEscape(str) abort
  return escape(a:str, '"$`\')
endfunction

" escape regex(7)
function! Regex7Escape(str) abort
  return escape(a:str, '*?.[]^(){}\$|')
endfunction

" escape vim pattern
function! PatternEscape(str) abort
  return escape(a:str, '.[]^()\$')
endfunction
