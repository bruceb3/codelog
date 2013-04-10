

"autocmd BufWritePre,BufRead * exec 'silent :! echo "%:p,`date`,`if [ -d $(pwd)/.git ]; then GIT_DIR=$(pwd)/.git git rev-parse --abbrev-ref HEAD; fi`,`if [ -d $(pwd)/.git ]; then GIT_DIR=$(pwd)/.git git log --pretty=format:\"\%h\" -n 1; fi`" >> ~/vim_files.csv &'

let g:codelog_file = $HOME . '/vim_files.csv'

function! s:Get_git_info()
  let l:git_dir = getcwd().'/.git'
  if isdirectory(l:git_dir)
    call s:store(g:codelog_file, join([s:date(), s:fullpath(), s:Branch_name(l:git_dir), s:Commit(l:git_dir)], ','))
  endif
endfunction

function! s:store(filename, string)
  return system("echo '" . a:string . "' >> '" . a:filename . "'")
endfunction

function! s:fullpath()
  return expand("%:p")
endfunction

function! s:date()
  return strftime("%c")
endfunction

function! s:Branch_name(git_dir)
  return s:chomp(system("GIT_DIR=" . a:git_dir . " git rev-parse --abbrev-ref HEAD") || 'N/A')
endfunction

function! s:Commit(git_dir)
  return s:chomp(system("GIT_DIR=" . a:git_dir . " git rev-parse --short HEAD") || 'N/A')
endfunction

function! s:chomp(string)
  return substitute(a:string, "\n", '', '')
endfunction

augroup CodeLog
  au!
  au BufWritePre,BufRead * call s:Get_git_info()
augroup END
