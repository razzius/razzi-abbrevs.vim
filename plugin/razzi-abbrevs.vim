inoremap <silent> <C-f> <C-o>:call InteractivelyAddIabbrev()<cr>

function! InteractivelyAddIabbrev()
  execute 'normal! bviwd'
  let word = getreg()
  let prompt = "Correction for " . word . ": "
  let correction = input(prompt, word)
  if col(".") == col("$")-1
    execute "normal! a" . correction
  else
    execute "normal! i" . correction
    execute "normal! l"
  endif

  let iabbrev = "Abolish " . word . " " . correction
  execute iabbrev

  let abbrevs_file = "~/.vim/plugins/razzi-abbrevs/plugin/razzi-abbrevs-list.vim"
  let cmd = "!echo " . iabbrev . " >> " . abbrevs_file
  silent execute cmd

  redraw!
endfunction

source "razzi-abbrevs-list.vim"
