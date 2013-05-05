

let g:codelog_file = $HOME . '/vim_files.csv'
let g:diff_options = '-u'

function! s:Get_git_info()
  let l:git_dir = getcwd().'/.git'
  if isdirectory(l:git_dir)
    call s:store(g:codelog_file, join([s:date(), s:fullpath(), s:Branch_name(l:git_dir), s:Commit(l:git_dir)], ','))
  else
    call s:store(g:codelog_file, join([s:date(), s:fullpath()], ','))
  endif
  call s:capture_diff(g:codelog_file) " for current buffer only
endfunction

function! s:store(filename, string)
  return system("echo '" . a:string . "' >> '" . a:filename . "'")
endfunction

function! s:capture_diff(filename)
  if strlen(expand('%')) > 0
    silent exec ":w !diff " g:diff_options " % - >> " a:filename "; exit 0"
  endif
endfunction

function! s:fullpath()
  return expand("%:p")
endfunction

function! s:date()
  return strftime("%c")
endfunction

function! s:Branch_name(git_dir)
  let l:branch_name = s:chomp(system("GIT_DIR=" . a:git_dir . " git rev-parse --abbrev-ref HEAD"))
  return (l:branch_name == '' ? 'N/A' : l:branch_name)
endfunction

function! s:Commit(git_dir)
  let l:commit = s:chomp(system("GIT_DIR=" . a:git_dir . " git rev-parse --short HEAD"))
  return (l:commit == '' ? 'N/A' : l:commit)
endfunction

function! s:chomp(string)
  return substitute(a:string, "\n", '', '')
endfunction

augroup CodeLog
  au!
  au BufWritePre,BufRead * call s:Get_git_info()
augroup end
