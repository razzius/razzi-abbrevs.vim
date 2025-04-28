inoremap <C-f> <C-o>:call InteractivelyAddIabbrev()<cr>

let g:abbrevs_file = expand("~/.vim/plugins/razzi-abbrevs/plugin/razzi-abbrevs-list.vim")
exec "source " . g:abbrevs_file

function! FindMatchingAbbrev(word)
  let check_abbrev = "iabbrev " . a:word

  let abbrev_result = execute(check_abbrev)

  let lines = split(abbrev_result, "\n")

  for line_text in lines
    let line = split(line_text)
    if line[1] == a:word
      return line[2]
    endif
  endfor

  return ""
endfunction

function! InteractivelyAddIabbrev()
  normal mz
  let column = col('.')
  let line = getline('.')
  let char = line[column - 1]

  let end_of_line = col(".") == col("$") - 1

  if ! end_of_line
    execute 'normal! h'
  endif

  execute 'normal! vb"ay'
  " Reset the cursor position in case the command is canceled
  normal `z

  let word = getreg('a')

  let matching_abbr = FindMatchingAbbrev(word)

  if matching_abbr != ""
    execute "normal! gvd"
    if ! end_of_line
      execute "normal! i" . matching_abbr
      execute "normal! l"
    else
      execute "normal! a" . matching_abbr
    endif
    return
  endif

  let prompt = "Correction for " . word . ": "
  let correction = input(prompt, word)
  execute "normal! gvd"

  if end_of_line
    execute "normal! a" . correction
  else
    execute "normal! i" . correction
    normal l
  endif

  let iabbrev = "iabbrev " . word . " " . correction
  execute iabbrev

  let old = readfile(g:abbrevs_file)
  call writefile(old + [iabbrev], g:abbrevs_file)
endfunction
