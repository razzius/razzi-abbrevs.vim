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
Abolish compuer computer
Abolish conenct connect
Abolish contorl control
Abolish control control
Abolish enviornment environment
Abolish forunately fortunately
Abolish foucs focus
Abolish hte the
Abolish hten then
Abolish jsut just
Abolish keboard keyboard
Abolish muslces muscles
Abolish ocpy copy
Abolish optoins options
Abolish propmt prompt
Abolish rae are
Abolish saerch search
Abolish serach search
Abolish somethign something
Abolish teh the
Abolish tping typing
Abolish urlpattersn urlpatterns
Abolish whic which
