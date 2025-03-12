inoremap <silent> <C-f> <C-o>:call InteractivelyAddIabbrev()<cr>

function! InteractivelyAddIabbrev()
  execute 'normal! bviw"_d'
  let word = getreg()
  let prompt = "Correction for " . word . ": "
  let correction = input(prompt, word)

  " TODO better handling for the word not being at the end of the line.
  " Also probably better to only read the word backwards so that if there's a
  " different word immediately following the cursor, it won't be included
  " as part of the fix.
  if col(".") == col("$")-1
    execute "normal! a" . correction
  else
    execute "normal! i" . correction
    execute "normal! l"
  endif

  let iabbrev = "Abolish " . word . " " . correction
  execute iabbrev

  let abbrevs_file = expand("~/.vim/plugins/razzi-abbrevs/plugin/razzi-abbrevs-list.vim")
  let old = readfile(abbrevs_file)
  call writefile(old + [iabbrev], abbrevs_file)
endfunction

source "razzi-abbrevs-list.vim"
