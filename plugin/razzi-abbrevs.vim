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

  let iabbrev = "iabbrev " . word . " " . correction
  let abbrevs_file = "~/.vim/plugins/razzi-abbrevs/plugin/razzi-abbrevs.vim"
  let cmd = "!echo " . iabbrev . " >> " . abbrevs_file
  silent execute cmd
  redraw!
endfunction

iabbrev adn and
iabbrev aroudn around
iabbrev awy away
iabbrev clickign clicking
iabbrev conenct connect
iabbrev control control
iabbrev forunately fortunately
iabbrev foucs focus
iabbrev hte the
iabbrev jsut just
iabbrev keboard keyboard
iabbrev muslces muscles
iabbrev ocpy copy
iabbrev propmt prompt
iabbrev rae are
iabbrev saerch search
iabbrev serach search
iabbrev somethign something
iabbrev tping typing
