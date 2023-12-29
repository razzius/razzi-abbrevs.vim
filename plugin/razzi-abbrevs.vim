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

  let abbrevs_file = "~/.vim/plugins/razzi-abbrevs/plugin/razzi-abbrevs.vim"
  let cmd = "!echo " . iabbrev . " >> " . abbrevs_file
  silent execute cmd

  redraw!
endfunction

Abolish adn and
Abolish aroudn around
Abolish awy away
Abolish clickign clicking
Abolish conenct connect
Abolish control control
Abolish forunately fortunately
Abolish foucs focus
Abolish hte the
Abolish jsut just
Abolish keboard keyboard
Abolish muslces muscles
Abolish ocpy copy
Abolish propmt prompt
Abolish rae are
Abolish saerch search
Abolish serach search
Abolish somethign something
Abolish tping typing
Abolish hten then
