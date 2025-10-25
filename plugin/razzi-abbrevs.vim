inoremap <C-f> <C-o>:call InteractivelyAddAbolish()<cr>

let g:abbrevs_file = expand("~/.vim/plugins/razzi-abbrevs/plugin/razzi-abbrevs-list.vim")
exec "source " . g:abbrevs_file

function! FindMatchingAbbrev(word)
  let check_abbrev = "Abolish " . a:word

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

function! InteractivelyAddAbolish()
  normal mz
  let column = col('.')
  let line = getline('.')
  let char = line[column - 1]

  let end_of_line = col(".") == col("$") - 1

  if ! end_of_line || char == '"'
    normal! h
  endif

  normal! vb"ay
  " Reset the cursor position in case the command is canceled
  normal `z

  let word = getreg('a')

  let matching_abbr = FindMatchingAbbrev(word)

  if matching_abbr != ""
    normal! gvd
    if ! end_of_line || char == '"'
      execute "normal! i" . matching_abbr
      normal! l
    else
      execute "normal! a" . matching_abbr
    endif
    return
  endif

  let prompt = "Correction for " . word . ": "
  let correction = input(prompt, word)
  normal! gvd

  if ! end_of_line || char == '"'
    execute "normal! i" . correction
    normal l
  else
    execute "normal! a" . correction
  endif

  let abolish = "Abolish " . word . " " . correction
  execute abolish

  let old = readfile(g:abbrevs_file)
  call writefile(old + [abolish], g:abbrevs_file)
endfunction
